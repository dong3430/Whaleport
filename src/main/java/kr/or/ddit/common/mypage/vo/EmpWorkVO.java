package kr.or.ddit.common.mypage.vo;


import lombok.Data;

@Data
public class EmpWorkVO {
	
	private int workNo;
	private int empNo;
	private String workDate;	 //근무 날짜
	private String workArrive;	 //출근시간
	private String workLeave;	//퇴근시간
	private int workNormal;		// 정상출근
	private int workLate;		//지각
	private int workEarly;		//조기퇴근
	private int workOff;		//결근
	private int workNochk;		// 퇴근 미체크
	private String workTime;		// 하루 일한 시간(-시간 -분)
	private int workAll;		// 하루 일한 시간(분 단위)
	private String month;		// 근태 원하는 월
	private int week;		// 근태 원하는 주
	private String date1;		// 근태 시작하는 주 날짜
	private String date2;		// 근태 끝나는 주 날짜
	
	private String todayTime;		// 00:00:00 형태의 누적시간
	
	private int sumWorkNormal;
	private int sumWorkLate;
	private int sumWorkEarly;
	private int sumWorkOff;
	private int sumWorkNochk;
	
} 
