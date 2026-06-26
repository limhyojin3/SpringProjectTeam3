package com.example.marryview.member.model;

import java.util.ArrayList;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ChatRequest {
    private List<Content> contents;
    private GenerationConfig generationConfig;

    @Getter @Setter
    public static class Content {
        private Parts parts;
    }

    @Getter @Setter
    public static class Parts {
        private String text;

    }

    @Getter @Setter
    public static class GenerationConfig {
        private int candidate_count;
        private int max_output_tokens;
        private double temperature;

    }
    public ChatRequest(String prompt) {
        this.contents = new ArrayList<>();
        Content content = new Content();
        Parts parts = new Parts();

        parts.setText(prompt);
        content.setParts(parts);

        this.contents.add(content);
        this.generationConfig = new GenerationConfig();
        this.generationConfig.setCandidate_count(1);
        this.generationConfig.setMax_output_tokens(4096); // 토큰 수, 한글1개 = 2-3토큰 소요
        this.generationConfig.setTemperature(0.7);
    }
}