package com.gaula.repository;

import com.gaula.entity.PasswordResetToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PasswordResetTokenRepository extends JpaRepository<PasswordResetToken, Long> {
    Optional<PasswordResetToken> findByToken(String token);
    Optional<PasswordResetToken> findByEmailAndTokenAndUsedFalse(String email, String token);
    Optional<PasswordResetToken> findTopByEmailAndUsedFalseOrderByExpiryDateDesc(String email);
}
