package com.remindue.models;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "tasks")
public class Task extends PanacheEntityBase {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    public Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", referencedColumnName = "user_id")
    public User user;

    @Column(name = "title", length = 255)
    public String title;

    @Column(name = "is_completed")
    public Boolean isCompleted = false;

    @Column(name = "color", length = 20)
    public String color;

    @Column(name = "created_at")
    public LocalDateTime createdAt;

    public Task() {}

    public Task(User user, String title, String color) {
        this.user = user;
        this.title = title;
        this.color = color;
        this.isCompleted = false;
        this.createdAt = LocalDateTime.now();
    }
}
