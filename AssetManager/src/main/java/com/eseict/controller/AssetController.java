package com.eseict.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.eseict.VO.AssetDetailVO;
import com.eseict.VO.AssetFormerUserVO;
import com.eseict.VO.AssetHistoryVO;
import com.eseict.VO.AssetTakeOutHistoryVO;
import com.eseict.VO.AssetVO;
import com.eseict.VO.CategoryVO;
import com.eseict.service.AssetService;
import com.eseict.service.EmployeeService;

@Controller
public class AssetController {
	
	@Autowired
	private AssetService aService;
	@Autowired
	private EmployeeService eService;
	
	@RequestMapping(value="/assetList")
	public ModelAndView assetList(RedirectAttributes redirectAttributes
								, @RequestParam(required = false) String searchMode
								, @RequestParam(required = false) String searchKeyword
								, HttpSession session) {
		try {
				if(searchKeyword != null) {
					if((Integer.parseInt(searchMode)>=1 && (Integer.parseInt(searchMode)<=4))) {
						return aService.assetListMnV(searchMode, searchKeyword);
					}
				} else {
					return aService.assetListMnV(null, null);
				}
		} catch (Exception e) {
			e.printStackTrace();
		}
		redirectAttributes.addFlashAttribute("msg", "에러 발생!");
		return new ModelAndView("error.tiles");
	}
	
	@RequestMapping(value="/myAssetList", method = RequestMethod.POST)
	public ModelAndView myAssetList(RedirectAttributes redirectAttributes
								, @RequestParam String employeeSeq
								, HttpSession session) {
		try {
				return aService.myAssetListMnV(null, null, Integer.parseInt(employeeSeq));
		} catch (Exception e) {
			e.printStackTrace();
		}
		redirectAttributes.addFlashAttribute("msg", "에러 발생!");
		return new ModelAndView("error.tiles");
	}
	
	@RequestMapping(value = "/assetDetail", method = RequestMethod.POST)
	public ModelAndView assetDetail(RedirectAttributes redirectAttributes
								  , @RequestParam(required=false) String assetId) {
		try {	
					return aService.assetDetailMnV(assetId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		redirectAttributes.addFlashAttribute("msg", "에러 발생!");
		return new ModelAndView("error.tiles");

	}

	@RequestMapping(value = "/assetRegister")
	public ModelAndView nameList2(RedirectAttributes redirectAttributes) {
		try {
			return aService.assetRegisterMnV();
		} catch (Exception e) {
			e.printStackTrace();
		}
		redirectAttributes.addFlashAttribute("msg", "에러 발생!");
		return new ModelAndView("error.tiles");
	}
	
	@Transactional
	@RequestMapping(value = "/assetRegisterSend")
	public ModelAndView assetRegister(RedirectAttributes redirectAttributes
							  , @ModelAttribute AssetVO avo
							  , @RequestParam(required=false) String assetOutObjective
							  , @RequestParam(required=false) String assetOutPurpose
	  					  	  , @RequestParam(required=false) String assetOutCost
	  					  	  , @RequestParam(required=false) String assetOutComment
	  					  	  , @RequestParam String[] items
							  , @RequestParam String[] itemsDetail
							  , @RequestParam(required=false) MultipartFile uploadImage
							  , HttpServletRequest request){

		try {
			// 관리 번호 생성
			String assetId = aService.generateAssetId(avo);
			String assetUser = null;
			
			avo.setAssetId(assetId);
			// 이미지 업로드
			avo.setAssetReceiptUrl(aService.uploadImageFile(request.getServletContext(), uploadImage));
			if(avo.getAssetUser() == null || avo.getAssetUser().equals("NoUser")) {
				avo.setAssetUser("사용자 없음");
				avo.setEmployeeSeq(0);
			}else {
				assetUser = avo.getAssetUser();
				avo.setEmployeeSeq(eService.getEmployeeSeqByEmpId(assetUser));
				avo.setAssetUser(eService.getEmployeeNameByEmpId(assetUser));
			}
			avo.setAssetManagerSeq(eService.getEmployeeSeqByEmpId(avo.getAssetManager()));
			avo.setAssetManager(eService.getEmployeeNameByEmpId(avo.getAssetManager()));
			aService.insertAsset(avo);
			
			// 자산 세부사항 등록 
			aService.insertAssetDetail(assetId, items, itemsDetail);
			// 자산 이력 등록
			if(avo.getAssetUser().equals("사용자 없음")) {
				aService.insertAssetHistory(assetId, null);
			}else {
				aService.insertAssetHistory(assetId, assetUser);
			}
			
			// 자산 등록 시 반출,수리 중이면 입력
			if(!assetOutObjective.isEmpty() && !assetOutPurpose.isEmpty() && !assetOutCost.isEmpty() 
					&& assetOutObjective != null && assetOutPurpose != null && assetOutCost != null) {
				AssetTakeOutHistoryVO atouhvo = new AssetTakeOutHistoryVO();
				atouhvo.setAssetId(assetId);
				atouhvo.setAssetOutStatus(avo.getAssetOutStatus());
				atouhvo.setAssetOutObjective(assetOutObjective);
				atouhvo.setAssetOutPurpose(assetOutPurpose);
				atouhvo.setAssetOutStartDate(new java.sql.Date(new java.util.Date().getTime()));
				atouhvo.setAssetOutCost(assetOutCost);
				atouhvo.setAssetOutComment(assetOutComment);
				aService.insertAssetTakeOutHistoryWhenRegister(atouhvo);
			}
			
			return new ModelAndView("assetBridge","assetId",assetId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		redirectAttributes.addFlashAttribute("msg", "에러 발생!");
		return new ModelAndView("error.tiles");
	}
	
	@RequestMapping(value = "/getCategoryDetailItem")
	@ResponseBody
	public List<CategoryVO> getCategoryDetailItem(RedirectAttributes redirectAttributes
												, @RequestParam String assetCategory) {
		try {
			List<CategoryVO> list = aService.getCategoryDetailItem(assetCategory);
			return list;
		} catch (Exception e) {
			e.printStackTrace();
		}
		redirectAttributes.addFlashAttribute("msg", "에러 발생!");
		return null;
	}
	
	@RequestMapping(value="assetModify")
	public ModelAndView assetModify(RedirectAttributes redirectAttributes
								  , @RequestParam String assetId) {
		try {
			return aService.assetModifyMnV(assetId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		redirectAttributes.addFlashAttribute("msg", "에러 발생!");
		return new ModelAndView("error.tiles");
	}
	
	// 자산 수정 Send
	@Transactional
	@RequestMapping(value = "/assetModifySend")
	public ModelAndView userModifySend(RedirectAttributes redirectAttributes
							   , @ModelAttribute AssetVO avo
							   , @ModelAttribute AssetDetailVO dvo
							   , @ModelAttribute AssetHistoryVO ahvo
							   , @ModelAttribute AssetFormerUserVO afuvo
							   , @RequestParam String[] items
							   , @RequestParam String[] itemsDetail
							   , @RequestParam String beforeUser
							   , @RequestParam(required=false) MultipartFile uploadImage
							   , HttpServletRequest request) {
		try {
			String assetId = avo.getAssetId();
			String assetUser = avo.getAssetUser();
			String UserEmpName = eService.getEmployeeNameByEmpId(assetUser);
			int newEmpSeq = 0;
			int empSeq = 0;
			
			// 아이디로 EmpSeq 구하기
			if(avo.getAssetUser().equals("NoUser") || avo.getAssetUser() == null) {
				newEmpSeq = 0;
				empSeq = eService.getEmployeeSeqByEmpId(beforeUser);;
				avo.setAssetUser("사용자 없음");
				avo.setEmployeeSeq(0);
			}else {
				newEmpSeq = eService.getEmployeeSeqByEmpId(assetUser);
				if(beforeUser != "" && beforeUser != null && !beforeUser.isEmpty()) {
					empSeq = eService.getEmployeeSeqByEmpId(beforeUser);
				} else {
					empSeq = 0;
				}
				avo.setAssetUser(UserEmpName);
				avo.setEmployeeSeq(newEmpSeq);
			}
			// 이미지 업로드
			avo.setAssetReceiptUrl(aService.uploadImageFile(request.getServletContext(), uploadImage));
			avo.setAssetManagerSeq(eService.getEmployeeSeqByEmpId(avo.getAssetManager()));
			avo.setAssetManager(eService.getEmployeeNameByEmpId(avo.getAssetManager()));
			aService.updateAsset(avo);
			aService.updateAssetDetail(assetId, items, itemsDetail);
			
			// 자산 수정 시 자산 이력 자동 입력
//			if(newEmpSeq != empSeq) {
				aService.updateAssetHistory(assetId, UserEmpName, empSeq, newEmpSeq);
//			} 
			return new ModelAndView("assetBridge","assetId",avo.getAssetId());
		} catch (Exception e) {
			e.printStackTrace();
		}
		redirectAttributes.addFlashAttribute("msg", "에러 발생!");
		return new ModelAndView("error.tiles");
	}
	
	@RequestMapping(value="/assetDisposal")	
	public String assetDisposal(RedirectAttributes redirectAttributes
							  , @RequestParam String[] assetIdList) {
		try {
			aService.updateAssetDisposal(assetIdList);
			return "redirect:/assetList.tiles";
		} catch (Exception e) {
			e.printStackTrace();
		}
		redirectAttributes.addFlashAttribute("msg", "에러 발생!");
		return "error.tiles";
	}
	
	@RequestMapping(value="/assetHistory")
	public ModelAndView assetHistory(RedirectAttributes redirectAttributes
								   , @RequestParam String assetId) {
		try {
			return aService.assetHistoryMnV(assetId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		redirectAttributes.addFlashAttribute("msg", "에러 발생!");
		return new ModelAndView("error.tiles");

	}
	
	@RequestMapping(value="/assetDelete")
	public String assetDelete(RedirectAttributes redirectAttributes
							, @RequestParam String assetId
							, @RequestParam("checkAdminPw") String checkAdminPw) {
		try {
			// 자산 삭제
			int check = eService.checkRegistered("admin", checkAdminPw);
			if (check == 1) {
				// 자산 삭제
				aService.deleteAssetById(assetId);	
				aService.deleteAssetDetailById(assetId);
				redirectAttributes.addFlashAttribute("msg", "삭제되었습니다.");
			} else {
				redirectAttributes.addFlashAttribute("msg", "비밀번호가 맞지 않아 삭제에 실패했습니다.");
			}
			return "redirect:/assetList";
		} catch (Exception e) {
			e.printStackTrace();
		}
		redirectAttributes.addFlashAttribute("msg", "에러 발생!");
		return "error.tiles";
	}
	
	@RequestMapping(value="/assetTakeOutHistory")
	public ModelAndView assetTakeOutHistory(RedirectAttributes redirectAttributes
									, @ModelAttribute AssetTakeOutHistoryVO atouhvo) {
		try {
			// 자산 반출/수리 이력 입력
			atouhvo.setAssetOutStartDate(new java.sql.Date(new java.util.Date().getTime()));
			aService.insertAssetTakeOutHistory(atouhvo);
			return new ModelAndView("assetHistoryBridge","assetId",atouhvo.getAssetId());
		} catch (Exception e) {
			e.printStackTrace();
		}
		redirectAttributes.addFlashAttribute("msg", "에러 발생!");
		return new ModelAndView("error.tiles");
	}
	
	@RequestMapping(value="/assetPayment")
	public ModelAndView assetPayment(RedirectAttributes redirectAttributes
							 , @RequestParam String assetId) {
		try {
			// 자산 납입 
			aService.upateAssetTakeOutHistory(assetId);
			return new ModelAndView("assetHistoryBridge","assetId",assetId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		redirectAttributes.addFlashAttribute("msg", "에러 발생!");
		return new ModelAndView("error.tiles");
	}
}