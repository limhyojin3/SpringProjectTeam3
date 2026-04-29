package com.example.demo.company.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.common.Message;
import com.example.demo.company.mapper.CompanyMapper;
import com.example.demo.company.model.Company;
import com.example.demo.company.model.Review;

@Service
public class CompanyService {
	@Autowired
	CompanyMapper companyMapper;

	// 조회 -> get, 수정 -> edit, 삽입 -> add, 삭제 -> remove
	// ex) 학생목록 : getStudentList, 학생수정 -> editStudent

	// === Mapper 호출 시 ===
	// 여러개 리턴 -> selectXXXList
	// List<User> list = defaultMapper.selectUserList();
	// 한개 리턴 -> selectXXX
	// User info = defaultMapper.selectUser();
	// 수정, 삭제, 삽입 -> updateXXX, deleteXXX, insertXXX
	// int result = defaultMapper.updateXXX();

	public HashMap<String, Object> getCompany(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
//			List<User> list = defaultMapper.selectUserList(map);
//			User info = defaultMapper.selectUser(map);
//			int result = defaultMapper.updateXXX(map);

//			resultMap.put("list", list);

			Company info = companyMapper.selectCompany(map);

			resultMap.put("info", info);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	public HashMap<String, Object> getProductList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
//			List<User> list = defaultMapper.selectUserList(map);
//			User info = defaultMapper.selectUser(map);
//			int result = defaultMapper.updateXXX(map);

//			resultMap.put("list", list);

			List<Company> list = companyMapper.selectProductList(map);

			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	public HashMap<String, Object> getProduct(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
//			List<User> list = defaultMapper.selectUserList(map);
//			User info = defaultMapper.selectUser(map);
//			int result = defaultMapper.updateXXX(map);

//			resultMap.put("list", list);

			List<String> tagList = companyMapper.selectTagList(map);

			Company info = companyMapper.selectProduct(map);

			resultMap.put("tagList", tagList);
			resultMap.put("info", info);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	// editProduct
	@Transactional(rollbackFor = Exception.class)
	public HashMap<String, Object> editProduct(Company product) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
//			List<User> list = defaultMapper.selectUserList(map);
//			User info = defaultMapper.selectUser(map);
//			int result = defaultMapper.updateXXX(map);

//			resultMap.put("list", list);

			int result = companyMapper.updateProduct(product);
			int result1 = 0;
			//[]
			if(product.getUniqueNewTagsOnly() != null && !product.getUniqueNewTagsOnly().isEmpty()) {
				result1 = companyMapper.insertUniqueNewTagsOnly(product);
			} else {
				System.out.println("보낼 태그가 없어서 insert를 건너뜁니다!");
			}
			
			
			
			if (result > 0) {
				
				if(result1 > 0) {
					resultMap.put("result", "success");
					resultMap.put("message", Message.MSG_ADD);
					resultMap.put("message1", "태그도 추가되었어요!");
				} else {
					resultMap.put("result", "success");
					resultMap.put("message", Message.MSG_ADD);
					resultMap.put("message1", "태그는 추가된게 없네요!");
				}
				
			}

		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	// companyService.addUniqueNewTagsOnly(product);
//	public HashMap<String, Object> addUniqueNewTagsOnly(Company product) {
//
//		HashMap<String, Object> resultMap = new HashMap<String, Object>();
//		try {
//			int result1 = companyMapper.insertUniqueNewTagsOnly(product);
//			System.out.println(result1);
//
//		} catch (Exception e) {
//		}
//		return resultMap;
//	}

	// insertProduct
	public HashMap<String, Object> addProduct(Company product) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
//			List<User> list = defaultMapper.selectUserList(map);
//			User info = defaultMapper.selectUser(map);
//			int result = defaultMapper.updateXXX(map);

//			resultMap.put("list", list);

			int result = companyMapper.insertProduct(product);

			int result1 = 0;
			//[]
			if(product.getUniqueNewTagsOnly() != null && !product.getUniqueNewTagsOnly().isEmpty()) {
				result1 = companyMapper.insertUniqueNewTagsOnly(product);
			} else {
				System.out.println("보낼 태그가 없어서 insert를 건너뜁니다!");
			}
			
			
			
			if (result > 0) {
				
				if(result1 > 0) {
					resultMap.put("result", "success");
					resultMap.put("message", Message.MSG_ADD);
					resultMap.put("message1", "태그도 추가되었어요!");
				} else {
					resultMap.put("result", "success");
					resultMap.put("message", Message.MSG_ADD);
					resultMap.put("message1", "태그는 추가된게 없네요!");
				}
				
			}

		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	// Company info = companyService.getCompanyInfo(userId);
	public Company getCompanyInfo(String userId) {
		try {
//			List<User> list = defaultMapper.selectUserList(map);
//			User info = defaultMapper.selectUser(map);
//			int result = defaultMapper.updateXXX(map);

//			resultMap.put("list", list);

			Company info = companyMapper.selectCompanyByUserId(userId);
			return info;

		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
		}
		return null;

	}

	public HashMap<String, Object> removeProduct(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
//			List<User> list = defaultMapper.selectUserList(map);
//			User info = defaultMapper.selectUser(map);
			int result = companyMapper.deleteProduct(map);

			if (result > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", Message.MSG_REMOVE);
			}

		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	// List<Company> selectReservation(HashMap<String, Object> map);
	public HashMap<String, Object> getReservation(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
//			List<User> list = defaultMapper.selectUserList(map);
//			User info = defaultMapper.selectUser(map);
			List<Company> list = companyMapper.selectReservation(map);
			// String selectNewResCnt(HashMap<String, Object> map);
			String newResCnt = companyMapper.selectNewResCnt(map);

			resultMap.put("newResCnt", newResCnt);
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_REMOVE);

		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	// Company selectNewReviewCnt(HashMap<String, Object> map);
	public HashMap<String, Object> getReviewCnt(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
//			List<User> list = defaultMapper.selectUserList(map);
//			User info = defaultMapper.selectUser(map);
			List<Company> list = companyMapper.selectReviewCnt(map);
			Company info = companyMapper.selectNewReviewCnt(map);
			resultMap.put("list", list);
			resultMap.put("info", info);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_REMOVE);

		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	// getSimpleReviewCnt
	public HashMap<String, Object> getSimpleReviewCnt(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
//			List<User> list = defaultMapper.selectUserList(map);
//			User info = defaultMapper.selectUser(map);
			List<Company> list = companyMapper.selectSimpleReviewCnt(map);
			Company info = companyMapper.selectNewSimpleReviewCnt(map);
			resultMap.put("list", list);
			resultMap.put("info", info);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_REMOVE);

		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	// Review selectReviewDetails3(HashMap<String, Object> map);
	public HashMap<String, Object> getReviewDetails3(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
//			List<User> list = defaultMapper.selectUserList(map);
//			User info = defaultMapper.selectUser(map);
			List<Review> list = companyMapper.selectReviewDetails3(map);

			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_REMOVE);

		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	// List<Review> selectSimpleReviewDetails3(HashMap<String, Object> map);
	public HashMap<String, Object> getSimpleReviewDetails3(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
//			List<User> list = defaultMapper.selectUserList(map);
//			User info = defaultMapper.selectUser(map);
			List<Review> list = companyMapper.selectSimpleReviewDetails3(map);

			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_REMOVE);

		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	// List<String> selectTagList(HashMap<String, Object> map);
	public HashMap<String, Object> getTagAndProductList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
//			List<User> list = defaultMapper.selectUserList(map);
//			User info = defaultMapper.selectUser(map);
			List<String> taglist = companyMapper.selectTagList(map);

			// List<Company> selectProductListForTag(HashMap<String, Object> map);
			List<Company> productListForTag = companyMapper.selectProductListForTag(map);

			resultMap.put("productListForTag", productListForTag);
			resultMap.put("taglist", taglist);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_REMOVE);

		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	// List<String> selectBookedTimes(HashMap<String, Object> map);
	public HashMap<String, Object> getBookedTimes(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
//			List<User> list = defaultMapper.selectUserList(map);
//			User info = defaultMapper.selectUser(map);
			List<String> list = companyMapper.selectBookedTimes(map);

			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_REMOVE);

		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	// int insertReservation(HashMap<String, Object> map);

	public HashMap<String, Object> addReservation(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
//			List<User> list = defaultMapper.selectUserList(map);
//			User info = defaultMapper.selectUser(map);
//			List<String> list = companyMapper.selectBookedTimes(map);

			// resultMap.put("list", list);

			int result = companyMapper.insertReservation(map);

			if (result > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", Message.MSG_REMOVE);
			}

		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	// List<Company> selectMyReservationList(HashMap<String, Object> map);
	public HashMap<String, Object> getMyReservationList(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
//			List<User> list = defaultMapper.selectUserList(map);
//			User info = defaultMapper.selectUser(map);
//			List<String> list = companyMapper.selectBookedTimes(map);

			// int checkOver30minute(HashMap<String, Object> map);
			// resultMap.put("list", list);

			/* 잠시 막아둠. 조회시 30분 지났는지 확인해서 CANCEL 로 바꿔주는거 */
			// int result30 = companyMapper.checkOver30minute(map);

			List<Company> list = companyMapper.selectMyReservationList(map);

			// resultMap.put("result30", result30);
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_REMOVE);

		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

//int insertPaymentFinal(HashMap<String, Object> map);
//	
//	int updatePaymentFinal(HashMap<String, Object> map);

	@Transactional(rollbackFor = Exception.class)
	public HashMap<String, Object> addAndEditPaymentFinal(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
//			List<User> list = defaultMapper.selectUserList(map);
//			User info = defaultMapper.selectUser(map);
//			List<String> list = companyMapper.selectBookedTimes(map);

			int result1 = companyMapper.insertPaymentFinal(map);

			System.out.println(map.get("payDate"));// 2026-04-27T03:05:39
			System.out.println(map.get("payNo")); // 16

			int result2 = companyMapper.updatePaymentFinal(map);

			// List<Company> list = companyMapper.selectMyReservationList(map);
			if (result1 > 0 && result2 > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", Message.MSG_REMOVE);
			}

		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getTagList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
//			List<User> list = defaultMapper.selectUserList(map);
//			User info = defaultMapper.selectUser(map);
//			int result = defaultMapper.updateXXX(map);

//			resultMap.put("list", list);

			List<String> tagList = companyMapper.selectTagList(map);

			resultMap.put("tagList", tagList);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

}