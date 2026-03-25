package com.remindue.models;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "users")
public class User extends PanacheEntityBase {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    public Integer userId;

    @Column(name = "username", length = 50)
    public String username;

    @Column(name = "email", length = 100, unique = true)
    public String email;

    @Column(name = "password", length = 255)
    public String password;

    @Column(name = "profile_image", columnDefinition = "TEXT")
    public String profileImage;

    @Column(name = "streak")
    public Integer streak = 0;

    @Column(name = "last_completed_date")
    public LocalDate lastCompletedDate;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    public List<Task> tasks;

    public User() {}

    public User(String username, String email, String password) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.streak = 0;
    }
}
