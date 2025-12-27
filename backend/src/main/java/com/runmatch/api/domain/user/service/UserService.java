package com.runmatch.api.domain.user.service;



import com.runmatch.api.domain.user.dto.UserJoinRequest;
import com.runmatch.api.domain.user.entity.User;
import com.runmatch.api.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true) // 기본적으로 읽기전용 (성능 최적화)
public class UserService {

    private final UserRepository userRepository;

    /**
     * 회원가입
     * TODO :: 실제론 apple 로그인 토큰 검증
     */
    @Transactional
    public Long join(UserJoinRequest request, MultipartFile profileImage) {

        String profileImageURL = null;

        if(profileImage != null && !profileImage.isEmpty()) {
            // TODO :: S3 버킷을 사용 하여 이미지를 저장 하거나, 로컬에 파일을 생성 하여 앱 내에서 파일을 불러오는 방식으로 처리
            //         예: profileImageUrl = s3Uploader.upload(profileImage);
            System.out.println("이미지 파일 이름"+ profileImage.getOriginalFilename());

            // 임시로 가짜 URL 넣어두기 ( DB 확인용 )
            profileImageURL = "http://my=-bucket.s3.com" +profileImage.getOriginalFilename();
        }

        // 2. 엔티티생성
        User user =  new User(
                request.getAppleUserId(),
                request.getNickname(),
                request.getEmail(),
                request.getGender(),
                request.getBirthDate(),
                request.getRegion(),
                profileImageURL
        );

        // 중복 체크
        if (userRepository.findByAppleUserId(request.getAppleUserId()).isPresent()) {
            throw new IllegalArgumentException("이미 가입된 사용자입니다.");
        }

        // DB에 저장
        userRepository.save(user);

        return user.getId();
    }

    /**
     * 유저 확인용
     * @param userId
     * @return " 없는 사용자 입니다 "
     */
    public User getUser(Long userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("없는 사용자 입니다."));
    }

}
