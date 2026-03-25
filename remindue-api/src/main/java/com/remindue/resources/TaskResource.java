package com.remindue.resources;

import com.remindue.dto.TaskRequest;
import com.remindue.dto.TaskResponse;
import com.remindue.models.Task;
import com.remindue.models.User;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;
import java.util.stream.Collectors;

@Path("/api/tasks")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class TaskResource {

    @GET
    @Path("/{userId}")
    public Response getTasksByUser(@PathParam("userId") Integer userId) {
        try {
            User user = User.findById(userId);
            if (user == null) {
                return Response.status(Response.Status.NOT_FOUND)
                    .entity("User not found")
                    .build();
            }

            List<Task> tasks = Task.find("user.userId = ?1 order by created_at desc", userId).list();
            List<TaskResponse> responses = tasks.stream()
                .map(t -> new TaskResponse(t.id, t.user.userId, t.title, t.isCompleted, t.color, t.createdAt))
                .collect(Collectors.toList());

            return Response.ok(responses).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity("Error retrieving tasks: " + e.getMessage())
                .build();
        }
    }

    @POST
    @Transactional
    public Response createTask(TaskRequest request) {
        try {
            if (request.userId == null || request.title == null || request.title.isEmpty() ||
                request.color == null || request.color.isEmpty()) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity("userId, title, and color are required")
                    .build();
            }

            User user = User.findById(request.userId);
            if (user == null) {
                return Response.status(Response.Status.NOT_FOUND)
                    .entity("User not found")
                    .build();
            }

            Task task = new Task(user, request.title, request.color);
            task.persist();

            TaskResponse response = new TaskResponse(task.id, task.user.userId, task.title, task.isCompleted, task.color, task.createdAt);

            return Response.status(Response.Status.CREATED).entity(response).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity("Error creating task: " + e.getMessage())
                .build();
        }
    }

    @DELETE
    @Path("/{id}")
    @Transactional
    public Response deleteTask(@PathParam("id") Integer id) {
        try {
            Task task = Task.findById(id);
            if (task == null) {
                return Response.status(Response.Status.NOT_FOUND)
                    .entity("Task not found")
                    .build();
            }

            task.delete();

            return Response.ok().build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity("Error deleting task: " + e.getMessage())
                .build();
        }
    }

    @PATCH
    @Path("/{id}/complete")
    @Transactional
    public Response completeTask(@PathParam("id") Integer id) {
        try {
            Task task = Task.findById(id);
            if (task == null) {
                return Response.status(Response.Status.NOT_FOUND)
                    .entity("Task not found")
                    .build();
            }

            task.isCompleted = true;
            task.persist();

            TaskResponse response = new TaskResponse(task.id, task.user.userId, task.title, task.isCompleted, task.color, task.createdAt);

            return Response.ok(response).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity("Error completing task: " + e.getMessage())
                .build();
        }
    }
}
