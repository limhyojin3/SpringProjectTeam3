package com.example.marryview.admin.dao;

import java.util.HashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import okhttp3.FormBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import java.util.ArrayList;
import java.util.List;

@Service
public class AdminReceiptOcrService {

    @Value("${ocr.space.api.url:https://api.ocr.space/parse/image}")
    private String apiUrl;

    @Value("${ocr.space.api.key:}")
    private String apiKey;

    private final OkHttpClient client = new OkHttpClient.Builder()
            .connectTimeout(15, java.util.concurrent.TimeUnit.SECONDS)
            .readTimeout(20, java.util.concurrent.TimeUnit.SECONDS)
            .build();

    public HashMap<String, Object> extractReceiptFields(String receiptUrl) {
        HashMap<String, Object> result = new HashMap<>();

        if (receiptUrl == null || receiptUrl.isBlank()) {
            result.put("available", false);
            result.put("message", "영수증 이미지가 없어 OCR을 실행하지 않았습니다.");
            return result;
        }

        if (apiKey == null || apiKey.isBlank()) {
            result.put("available", false);
            result.put("message", "OCR API 키가 설정되지 않았습니다.");
            return result;
        }

        try {
            String rawText = callOcrApi(receiptUrl);

            result.put("available", true);
            result.put("rawText", rawText);
            List<HashMap<String, Object>> amountCandidates = extractAmountCandidates(rawText);
            HashMap<String, Object> productTotal = findAmountCandidate(amountCandidates, "상품 총액", "상품총액", "총액");
            HashMap<String, Object> paymentTotal = findAmountCandidate(amountCandidates, "합계", "결제금액", "승인금액", "받을금액", "예약금");

            result.put("extractedDate", extractDate(rawText));
            result.put("amountCandidates", amountCandidates);

            if (productTotal != null) {
                result.put("productTotalAmount", productTotal.get("amount"));
                result.put("productTotalLabel", productTotal.get("label"));
            }

            if (paymentTotal != null) {
                result.put("paymentAmount", paymentTotal.get("amount"));
                result.put("paymentLabel", paymentTotal.get("label"));
            }

            if (productTotal != null) {
                result.put("extractedAmount", productTotal.get("amount"));
                result.put("amountLabel", productTotal.get("label"));
            } else if (paymentTotal != null) {
                result.put("extractedAmount", paymentTotal.get("amount"));
                result.put("amountLabel", paymentTotal.get("label"));
            } else if (!amountCandidates.isEmpty()) {
                result.put("extractedAmount", amountCandidates.get(0).get("amount"));
                result.put("amountLabel", amountCandidates.get(0).get("label"));
            }

            result.put("message", "OCR 추출 완료");

        } catch (Exception e) {
            result.put("available", false);
            result.put("message", "OCR 처리 중 오류가 발생했습니다.");
            result.put("error", e.getMessage());
        }

        return result;
    }

    private String callOcrApi(String receiptUrl) throws Exception {
        RequestBody body = new FormBody.Builder()
                .add("apikey", apiKey)
                .add("url", receiptUrl)
                .add("language", "kor")
                .add("isOverlayRequired", "false")
                .add("isTable", "true")
                .add("OCREngine", "2")
                .build();

        Request request = new Request.Builder()
                .url(apiUrl)
                .post(body)
                .build();

        try (Response response = client.newCall(request).execute()) {
            String responseBody = response.body() == null ? "" : response.body().string();

            if (!response.isSuccessful()) {
                throw new IllegalStateException("OCR API 응답 실패: " + response.code());
            }

            JsonObject root = JsonParser.parseString(responseBody).getAsJsonObject();

            if (root.has("IsErroredOnProcessing")
                    && root.get("IsErroredOnProcessing").getAsBoolean()) {
                throw new IllegalStateException(responseBody);
            }

            JsonArray parsedResults = root.getAsJsonArray("ParsedResults");

            if (parsedResults == null || parsedResults.size() == 0) {
                return "";
            }

            JsonObject first = parsedResults.get(0).getAsJsonObject();

            return first.has("ParsedText")
                    ? first.get("ParsedText").getAsString()
                    : "";
        }
    }

    private String extractDate(String text) {
        if (text == null) {
            return null;
        }

        Pattern pattern = Pattern.compile(
                "(20\\d{2})[.\\-/년\\s]*(0?[1-9]|1[0-2])[.\\-/월\\s]*(3[01]|[12]\\d|0?[1-9])"
        );

        Matcher matcher = pattern.matcher(text);

        if (!matcher.find()) {
            return null;
        }

        return String.format(
                "%s-%02d-%02d",
                matcher.group(1),
                Integer.parseInt(matcher.group(2)),
                Integer.parseInt(matcher.group(3))
        );
    }

    private Integer extractAmount(String text) {
        if (text == null || text.isBlank()) {
            return null;
        }

        String[] lines = text.split("\\r?\\n");
        Integer bestAmount = null;

        Pattern labeledPattern = Pattern.compile(
                "(합계|총액|총\\s*금액|결제\\s*금액|받을\\s*금액|승인\\s*금액|청구\\s*금액|카드\\s*금액|Total|TOTAL|Amount|AMOUNT|Cash|CASH)\\s*[:：]?\\s*([0-9,]+(?:\\.[0-9]+)?)",
                Pattern.CASE_INSENSITIVE
        );

        for (String line : lines) {
            if (isExcludedAmountLine(line)) {
                continue;
            }

            Matcher labeledMatcher = labeledPattern.matcher(line);

            while (labeledMatcher.find()) {
                Integer amount = parseAmount(labeledMatcher.group(2));

                if (isValidAmountCandidate(amount)
                        && (bestAmount == null || amount > bestAmount)) {
                    bestAmount = amount;
                }
            }
        }

        if (bestAmount != null) {
            return bestAmount;
        }

        Pattern wonPattern = Pattern.compile("([0-9]{1,3}(?:,[0-9]{3})+|[0-9]{4,7})\\s*(원|₩)");

        for (String line : lines) {
            if (isExcludedAmountLine(line)) {
                continue;
            }

            Matcher wonMatcher = wonPattern.matcher(line);

            while (wonMatcher.find()) {
                Integer amount = parseAmount(wonMatcher.group(1));

                if (isValidAmountCandidate(amount)
                        && (bestAmount == null || amount > bestAmount)) {
                    bestAmount = amount;
                }
            }
        }

        if (bestAmount != null) {
            return bestAmount;
        }

        Pattern fallbackPattern = Pattern.compile("([0-9]{1,3}(?:,[0-9]{3})+|[0-9]{4,7})");

        for (String line : lines) {
            if (isExcludedAmountLine(line)) {
                continue;
            }

            Matcher fallbackMatcher = fallbackPattern.matcher(line);

            while (fallbackMatcher.find()) {
                Integer amount = parseAmount(fallbackMatcher.group(1));

                if (isValidAmountCandidate(amount)
                        && (bestAmount == null || amount > bestAmount)) {
                    bestAmount = amount;
                }
            }
        }

        return bestAmount;
    }

    private boolean isExcludedAmountLine(String line) {
        if (line == null) {
            return true;
        }

        String normalized = line.toLowerCase();

        return normalized.contains("tel")
                || normalized.contains("phone")
                || normalized.contains("approval")
                || normalized.contains("code")
                || normalized.contains("사업자")
                || normalized.contains("사업자번호")
                || normalized.contains("전화")
                || normalized.contains("대표")
                || normalized.contains("주소")
                || normalized.contains("address")
                || normalized.contains("bank card")
                || normalized.contains("card no")
                || normalized.contains("카드번호")
                || normalized.contains("승인번호");
    }
    
    private boolean isValidAmountCandidate(Integer amount) {
        if (amount == null) {
            return false;
        }

        return amount >= 1000 && amount <= 9999999;
    }
    
    private Integer parseAmount(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }

        try {
            String normalized = value.replace(",", "").trim();

            if (normalized.contains(".")) {
                double decimal = Double.parseDouble(normalized);

                if (decimal < 1000) {
                    return null;
                }

                return (int) Math.round(decimal);
            }

            if (normalized.length() >= 8) {
                return null;
            }

            return Integer.parseInt(normalized);

        } catch (Exception e) {
            return null;
        }
    }
    
    private List<HashMap<String, Object>> extractAmountCandidates(String text) {
        List<HashMap<String, Object>> candidates = new ArrayList<>();

        if (text == null || text.isBlank()) {
            return candidates;
        }

        String[] lines = text.split("\\r?\\n");
        Pattern amountPattern = Pattern.compile("([0-9]{1,3}(?:,[0-9]{3})+|[0-9]{4,7})\\s*(원|₩)?");

        for (String line : lines) {
            if (line == null || line.isBlank()) {
                continue;
            }

            if (isExcludedAmountLine(line)) {
                continue;
            }

            Matcher matcher = amountPattern.matcher(line);

            while (matcher.find()) {
                Integer amount = parseAmount(matcher.group(1));

                if (!isValidAmountCandidate(amount)) {
                    continue;
                }

                String label = line.substring(0, matcher.start()).trim();
                label = label.replaceAll("\\s+", " ");

                if (label.isBlank()) {
                    label = "금액 후보";
                }

                HashMap<String, Object> candidate = new HashMap<>();
                candidate.put("label", label);
                candidate.put("amount", amount);
                candidate.put("line", line.trim());

                candidates.add(candidate);
            }
        }

        return candidates;
    }
    
    private HashMap<String, Object> findAmountCandidate(
            List<HashMap<String, Object>> candidates,
            String... keywords) {

        if (candidates == null || candidates.isEmpty()) {
            return null;
        }

        for (String keyword : keywords) {
            for (HashMap<String, Object> candidate : candidates) {
                String label = String.valueOf(candidate.getOrDefault("label", ""));
                String line = String.valueOf(candidate.getOrDefault("line", ""));

                if (label.contains(keyword) || line.contains(keyword)) {
                    return candidate;
                }
            }
        }

        return null;
    }
}