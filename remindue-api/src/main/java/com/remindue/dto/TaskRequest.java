package com.remindue.dto;

public class TaskRequest {
    public Integer userId;
    public String title;
    public String color;

    public TaskRequest() {}

    public TaskRequest(Integer userId, String title, String color) {
        this.userId = userId;
        this.title = title;
        this.color = color;
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

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }
}
