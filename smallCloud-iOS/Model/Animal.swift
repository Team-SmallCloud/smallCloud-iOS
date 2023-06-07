//
//  animal.swift
//  smallCloud-iOS
//
//  Created by WS on 2023/06/06.
//

import Foundation

struct AnimalInfo:Codable {
    let desertionNo:String //유기번호
    let filename:String //사진url
    let happenDt:String //접수일
    let happenPlace:String //발견장소
    let kindCd:String //종
    let colorCd:String //색상
    let age:String //나이
    let weight:String //체중
    let noticeNo:String //공고번호
    let noticeSdt:String//공고시작일
    let noticeEdt:String//공고종료일
    let popfile:String //이미지url
    let processState:String //상태(보호중, **)
    let sexCd:String //성별
    let neuterYn:String //중성화여부
    let specialMark:String //특징
    let careNm:String //보호소 이름
    let careTel:String //보호소 연락처
    let careAddr:String //보호소 주소
    let orgNm:String //관할기관
    let chargeNm:String //당담자 이름
    let officetel:String //담당자 전화번호
    let vnoticeComment:String? //특이사항 (선택반환)
}

struct Item: Codable {
    let item: [AnimalInfo]
}

struct Body: Codable {
    let items: Item //동물 데이터
    let numOfRows: Int //한 페이지의 검색결과 수
    let pageNo: Int //현재 페이지 번호
    let totalCount: Int //전체 검색결과 수
}

struct Header: Codable {
    let reqNo: Int //요청번호
    let resultCode: String //결과코드
    let resultMsg: String //결과메시지
}

struct Response: Codable {
    let header: Header
    let body: Body
}

struct AnimalResponse: Codable {
    let response: Response
}

struct WantedAnimal:Codable {
    let id: Int
    let name:String //이름
    let kind:String //종
    let NFC_id:String //RFID값
    let owner_id:Int  //주인ID
    let gender:String //성별
    let shape:String //사진?
    let place:String //실종장소
    let gratuity:Int //사례금
    let hppdDate:String //실종날짜
    let weight:Int //무게
    let phone:String //연락처
    let age:Int //나이
    let color:String //색상
    let detail:String //설명
    let neutered:Bool //중성화여부
}


