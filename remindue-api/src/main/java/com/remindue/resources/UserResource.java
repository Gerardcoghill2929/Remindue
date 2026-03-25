package com.remindue.resources;

import com.remindue.dto.UserRequest;
import com.remindue.dto.UserResponse;
import com.remindue.models.User;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;
import java.util.stream.Collectors;

@Path("/api/users")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class UserResource {

    @GET
    public Response getAllUsers() {
        try {
            List<User> users = User.listAll();
            List<UserResponse> responses = users.stream()
                .map(u -> new UserResponse(u.userId, u.username, u.email, u.password, u.profileImage, u.streak, u.lastCompletedDate))
                .collect(Collectors.toList());

            return Response.ok(responses).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity("Error retrieving users: " + e.getMessage())
                .build();
        }
    }

    @GET
    @Path("/{userId}")
    public Response getUserById(@PathParam("userId") Integer userId) {
        try {
            User user = User.findById(userId);
            if (user == null) {
                return Response.status(Response.Status.NOT_FOUND)
                    .entity("User not found")
                    .build();
            }

            UserResponse response = new UserResponse(user.userId, user.username, user.email, user.password, user.profileImage, user.streak, user.lastCompletedDate);

            return Response.ok(response).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity("Error retrieving user: " + e.getMessage())
                .build();
        }
    }

    @GET
    @Path("/email/{email}")
    public Response getUserByEmail(@PathParam("email") String email) {
        try {
            if (email == null || email.isBlank()) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity("Email is required")
                    .build();
            }

            User user = User.find("email = ?1", email).firstResult();
            if (user == null) {
                return Response.status(Response.Status.NOT_FOUND)
                    .entity("User not found")
                    .build();
            }

            UserResponse response = new UserResponse(user.userId, user.username, user.email, user.password, user.profileImage, user.streak, user.lastCompletedDate);

            return Response.ok(response).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity("Error retrieving user by email: " + e.getMessage())
                .build();
        }
    }

    @POST
    @Transactional
    public Response createUser(UserRequest request) {
        try {
            if (request.email == null || request.email.isEmpty() ||
                request.password == null || request.password.isEmpty() ||
                request.username == null || request.username.isEmpty()) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity("All fields are required")
                    .build();
            }

            User existingUser = User.find("email = ?1", request.email).firstResult();
            if (existingUser != null) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity("Email already exists")
                    .build();
            }

            User newUser = new User(request.username, request.email, request.password);
            newUser.persist();

            UserResponse response = new UserResponse(newUser.userId, newUser.username, newUser.email, newUser.password, newUser.profileImage, newUser.streak, newUser.lastCompletedDate);

            return Response.status(Response.Status.CREATED).entity(response).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity("Error creating user: " + e.getMessage())
                .build();
        }
    }

    @PUT
    @Path("/{userId}")
    @Transactional
    public Response updateUser(@PathParam("userId") Integer userId, UserRequest request) {
        try {
            User user = User.findById(userId);
            if (user == null) {
                return Response.status(Response.Status.NOT_FOUND)
                    .entity("User not found")
                    .build();
            }

            if (request.username != null && !request.username.isEmpty()) {
                user.username = request.username;
            }
            if (request.email != null && !request.email.isEmpty()) {
                user.email = request.email;
            }
            if (request.password != null && !request.password.isEmpty()) {
                user.password = request.password;
            }

            user.persist();

            UserResponse response = new UserResponse(user.userId, user.username, user.email, user.password, user.profileImage, user.streak, user.lastCompletedDate);

            return Response.ok(response).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity("Error updating user: " + e.getMessage())
                .build();
        }
    }

    @DELETE
    @Path("/{userId}")
    @Transactional
    public Response deleteUser(@PathParam("userId") Integer userId) {
        try {
            User user = User.findById(userId);
            if (user == null) {
                return Response.status(Response.Status.NOT_FOUND)
                    .entity("User not found")
                    .build();
            }

            user.delete();

            return Response.ok().build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity("Error deleting user: " + e.getMessage())
                .build();
        }
    }
}
