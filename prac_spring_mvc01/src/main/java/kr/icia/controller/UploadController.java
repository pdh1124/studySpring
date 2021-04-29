package kr.icia.controller;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
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
	
	
	
	//모든 파일은 내부적으로 bit값을 가짐.(문서, 영상, 이미지, 소리)
	//비트 스트림을 재조합하여 파일로 구성.
	//OTCTE : 8비트 흐름으로 STREAM 형태로 변형해서 한다. (책 500권을 다른방으로 옮길 때 들 수 있는 만큼 들어서 여러번 옮기는것과 같은 느낌)
	@GetMapping(value = "/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent") String userAgent, String fileName) {
		//서버에 접속한 브라우저의 정보는
		//헤더의 User-Agent를 보면 알 수 있음.
		
		//import org.springframework.core.io.Resource;
		Resource resource = new FileSystemResource("c:\\upload\\" + fileName);
		//파일을 리소스(자원: 가공 처리를 위한 중간 단계)로 변경. 파일을 비트값으로 전환.
		log.info("resource: " + resource);
		
		if(resource.exists() == false) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		String resourceName = resource.getFilename();
		//리소스에서 파일명을 찾아서 할당.
		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_") + 1);
		// uuid 를 제외한 파일명 만들기.
		// import org.springframework.http.HttpHeaders;
		HttpHeaders headers = new HttpHeaders();
		
		//웹 브라우저별 특성 처리 (한글 변환)
		try {
			String downloadName = null;
			
			if (userAgent.contains("Trident")) {
				log.info("IE browser");
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8").replace("\\", " "); 
			} else if (userAgent.contains("Edge")) {
				log.info("Edge browser");
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8");
			} else {
				log.info("Chrome browser");
				downloadName = new String(resourceOriginalName.getBytes("UTF-8"), "ISO-8859-1");
			}
			
			log.info("downloadName: " + downloadName);
			headers.add("Content-disposition", "attachment; filename=" + downloadName);
			// 헤더에 파일 다운로드 정보 추가.
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		
		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}
}
