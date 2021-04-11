package kr.icia.persistence;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import kr.icia.mapper.TimeMapper;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

//현재 클래스는 테스트를 위한 클래스이다.
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class TimeMapperTests {

	@Setter(onMethod_ = @Autowired)
	private TimeMapper timeMapper; // 멤버변수
	// @Setter : setter 메소드 자동 생성.
	// @Autowired : 생성된 객체 자동 연결.매개변수로들어간 setTimeMapper(TimeMapper)의 매개변수 TimeMapper를 초기화시켜서 연결시켜 준다. 

	// 점검 삼아서 구동해볼 메소드라고 알려줌.
	@Test
	public void testGetTime() { // 메소드
		log.info(timeMapper.getTime());
	}
}
