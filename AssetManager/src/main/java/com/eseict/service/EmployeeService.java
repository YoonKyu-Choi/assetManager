package com.eseict.service;

import com.eseict.VO.EmployeeVO;

public interface EmployeeService {
	// 새 사용자를 추가
	public void newEmployee(EmployeeVO vo);
	
	// 존재하는 아이디일 경우 1을 반환, 아니면 0을 반환
	public int checkIdDuplication(String employeeId);
	
	// 등록된 사용자일 경우 1을 반환, 아니면 0을 반환
	public int checkRegistered(String employeeId, String employeePw);

}
