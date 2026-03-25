package com.remindue.dto;

import java.time.LocalDateTime;

public class TaskResponse {
    public Integer id;
    public Integer userId;
    public String title;
    public Boolean isCompleted;
    public String color;
    public LocalDateTime createdAt;

    public TaskResponse() {}

    public TaskResponse(Integer id, Integer userId, String title, Boolean isCompleted, String color, LocalDateTime createdAt) {
        this.id = id;
        this.userId = userId;
        this.title = title;
        this.isCompleted = isCompleted;
        this.color = color;
        this.createdAt = createdAt;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Boolean getIsCompleted() {
        return isCompleted;
    }

    public void setIsCompleted(Boolean isCompleted) {
        this.isCompleted = isCompleted;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
