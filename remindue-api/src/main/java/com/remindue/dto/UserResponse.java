package com.remindue.dto;

import java.time.LocalDate;

public class UserResponse {
    public Integer userId;
    public String username;
    public String email;
    public String password;
    public String profileImage;
    public Integer streak;
    public LocalDate lastCompletedDate;

    public UserResponse() {}

    public UserResponse(Integer userId, String username, String email, String password, String profileImage, Integer streak, LocalDate lastCompletedDate) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.password = password;
        this.profileImage = profileImage;
        this.streak = streak;
        this.lastCompletedDate = lastCompletedDate;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getProfileImage() {
        return profileImage;
    }

    public void setProfileImage(String profileImage) {
        this.profileImage = profileImage;
    }

    public Integer getStreak() {
        return streak;
    }

    public void setStreak(Integer streak) {
        this.streak = streak;
    }

    public LocalDate getLastCompletedDate() {
        return lastCompletedDate;
    }

    public void setLastCompletedDate(LocalDate lastCompletedDate) {
        this.lastCompletedDate = lastCompletedDate;
    }
}
