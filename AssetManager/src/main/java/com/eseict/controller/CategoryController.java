package com.eseict.controller;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.eseict.service.AssetService;
import com.eseict.service.CategoryService;
import com.eseict.service.EmployeeService;

@Controller
public class CategoryController {
	
	@Autowired
	private AssetService aService;
	
	@Autowired
	private CategoryService cService;
	
	@Autowired
	private EmployeeService eService;

	@RequestMapping(value="/categoryList")
	public ModelAndView categoryList(Model model, @RequestParam(required = false) String searchMode, @RequestParam(required = false) String searchKeyword) {

		if(searchKeyword != null) {
			return cService.categoryListMnV(searchMode, searchKeyword);
		} else {
			return cService.categoryListMnV(null, null);
		}
	}

	
	@RequestMapping(value="/categoryDetail")
	public ModelAndView categoryDetail(@RequestParam String categoryName) {
		return cService.categoryDetailMnV(categoryName);
	}
	
	
	@RequestMapping(value="/categoryRegister")
	public String categoryRegister() {
		return "categoryRegister.tiles";
	}
	
	@RequestMapping(value="/categoryRegisterSend")
	public String categoryRegisterSend(RedirectAttributes redirectAttributes, @RequestParam String categoryName, @RequestParam String[] items, @RequestParam String code) {
		boolean  dup = cService.categoryRegisterSend(categoryName, items);
		if(dup) {
			redirectAttributes.addFlashAttribute("msg", "이미 존재하는 분류이므로 해당 분류에 추가되었습니다.");
		} else {
			cService.newCode(categoryName, code);
			redirectAttributes.addFlashAttribute("msg", "등록되었습니다.");
		}
		return "redirect:/categoryList";
	}
	
	@RequestMapping(value="/categoryDelete")
	public String categoryDelete(RedirectAttributes redirectAttributes, @RequestParam String categoryName, @RequestParam("checkAdminPw") String checkAdminPw) {
		int check = eService.checkRegistered("admin", checkAdminPw);
		if (check == 1) {
			cService.deleteCategory(categoryName);
			for(String assetId: aService.getAssetIdListByCategory(categoryName)) {
				aService.deleteAssetById(assetId);
			}
			cService.deleteCode(categoryName);
			redirectAttributes.addFlashAttribute("msg", "삭제되었습니다.");
		} else {
			redirectAttributes.addFlashAttribute("msg", "비밀번호가 맞지 않아 삭제에 실패했습니다.");
		}
		return "redirect:/categoryList";
	}
	
	@RequestMapping(value="/categoryModify")
	public ModelAndView categoryModify(@RequestParam String categoryName) {
		return cService.categoryModifyMnV(categoryName);
	}
	
	@RequestMapping(value="/categoryModifySend")
	public String categoryModifySend(RedirectAttributes redirectAttributes, @RequestParam String categoryOriName, @RequestParam String categoryName, @RequestParam String[] items, @RequestParam String[] deleteItems) {
		int checkName = cService.categoryModifyCheckName(categoryOriName, categoryName);
		ArrayList<Integer> deleteItemsList = cService.categoryModifyItemDelete(categoryName, deleteItems);		
		cService.categoryModifyItemUpdate(categoryName, items, deleteItemsList);
		redirectAttributes.addFlashAttribute("msg", "수정되었습니다.");
		return "redirect:/categoryList";
	}

	@RequestMapping(value = "/checkCode")
	@ResponseBody
	public String checkId(@RequestParam(value = "code", required = false) String inputCode, HttpServletResponse response) throws IOException {
		if (!inputCode.isEmpty()) {
			return String.valueOf(cService.existsCode(inputCode));
		} else {
			return "empty";
		}
	}
}
