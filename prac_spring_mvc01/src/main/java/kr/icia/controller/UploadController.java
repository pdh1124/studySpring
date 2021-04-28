package kr.icia.controller;

import java.io.File;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.icia.domain.AttachFileDTO;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class UploadController {
	String uploadFolder = "c:\\upload";
	
	//ResponseBody: 응답 결과물을 json 타입(produces에 말한)으로 변경하여 요청한 페이지로 전달하겠다.
	@PostMapping(value = "/uploadAjaxAction", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {
		// MultipartFile[] : 여러개의 파일을 받아올 수 있다.
		// rest 방식으로 ajax 처리.
		// 파일을 받고 json 값을 리턴
		 
		List<AttachFileDTO> list = new ArrayList<>();
		// 여러개 파일 저장을 위한 객체 배열 타입 선언.
		// 컬렉션 프레임워크의 list 타입.
		// String uploadFolder = "c:\\upload";
		
		String uploadFolderPath = getFolder();
		File uploadPath = new File(uploadFolder, uploadFolderPath);
		// 예) c:\\upload\\2021\\04\\28 에 파일 저장 예정.
		
		if (uploadPath.exists() == false) {
			uploadPath.mkdirs();
			// 경로에 폴더들이 생성되어 있지 않다면, 폴더 생성
		}
		
		//파일은 1개 일수도 있고, 여러개 일수도 있음.
		for (MultipartFile multipartFile : uploadFile) {
			AttachFileDTO attachDTO = new AttachFileDTO();
			String uploadFileName = multipartFile.getOriginalFilename();
			//파일의 원래 이름 저장.
			
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);
			//인터넷 익스플로러 경우, 예외 처리
			
			attachDTO.setFileName(uploadFileName);
			// 파일 이름 저장.
			
			UUID uuid = UUID.randomUUID();
			// universal unique identifier, 범용 고유 식별자.
			// 파일의 종복을 회피
			
			uploadFileName = uuid.toString() + "_" + uploadFileName;
			// 예) uuid_일일일.txt
			
			try {
				File saveFile = new File(uploadPath, uploadFileName);
				multipartFile.transferTo(saveFile);
				// 서버에 파일 저장.
				
				attachDTO.setUuid(uuid.toString());
				attachDTO.setUploadPath(uploadFolderPath);
				
				list.add(attachDTO);
				//업로드된 파일 정보를 객체 배열에 담아서 리턴.
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return new ResponseEntity<>(list, HttpStatus.OK);	
	}

	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");//현재 시스템의 날짜를 이용해서
		Date date = new Date();
		String str = sdf.format(date); //문자열로 리턴한다.
		//포멧을 만들어 주는 부분
		return str.replace("-", File.separator);
		// 파일 검색 시간을 줄이기 위해
		// 폴더 1개에 모두 저장하는 것이 아니라.
		// 년월일로 구분하여 폴더를 생성하고 그곳에 파일을 저장.
		// File.sparator : 폴더 구분자를 운영체제에 맞춰서 변경.
		// 윈도우,리눅스,맥 마다 (‘\’, ‘/‘, ‘:’)로 나누는데 File.separator를 사용하면
		// 모든 운영체제에 맞게 변경이 된다.
		// 2021-04-28
		// 2021/04/28로 결과적으로 날짜별로 파일 저장. 
	}
	
	//파일 삭제 
	@PostMapping("/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName, String type) {
		
		log.info("deleteFile: "	+ fileName);
		File file;
		
		try {
			file = new File("c:\\upload\\" + URLDecoder.decode(fileName,"UTF-8"));
			// 한글의 경우, 페이지 전환시 변경됨.
			// 알맞는 문자 포맷으로 해석해서 읽어 들여야 함.
			file.delete();
			//파일 삭제.
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity<String>("deleted", HttpStatus.OK);
	}
}
