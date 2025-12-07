package com.runmatch.api.global.util;

import lombok.experimental.UtilityClass;

public class StringUtil {

    //인스턴스 생성 방지
    private StringUtil() {}

    /**
     * 이메일 정제(공백 제거 + 소문자 변환)
     * null이 들어오면 빈 문자열 반환 (NullPointerException 방지)
     */
    public static String sanitizeEmail(String email) {
        if (email == null) {
            return "";
        }

        return email.trim().toLowerCase();
    }

    /**
     * 일반 코드/문자열 정제 (단순 공백 제거)
     */
    public static String sanitizeCode(String code) {
        if(code == null) {
            return "";
        }
        return code.trim();
    }

}
