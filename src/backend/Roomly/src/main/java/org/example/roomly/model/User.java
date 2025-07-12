package org.example.roomly.model;

import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import org.springframework.stereotype.Component;

import java.util.List;


//@JsonTypeInfo(
//        use = JsonTypeInfo.Id.NAME, // can also use CLASS if you want full class names
//        include = JsonTypeInfo.As.PROPERTY,
//        property = "type" // this field must exist in JSON input
//)
//@JsonSubTypes({
//        @JsonSubTypes.Type(value = Customer.class, name = "CUSTOMER"),
//        @JsonSubTypes.Type(value = WorkspaceStaff.class, name = "WORKSPACE_STAFF"),
//        @JsonSubTypes.Type(value = WorkspaceStaff.class, name = "ADMIN"),
//        @JsonSubTypes.Type(value = WorkspaceStaff.class, name = "WORKER"),
//        @JsonSubTypes.Type(value = WorkspaceStaff.class, name = "MANAGER"),
//        @JsonSubTypes.Type(value = WorkspaceStaff.class, name = "DEFAULT")
//})
@Component
public abstract class User {
    private String Id;
    private String firstName;
    private String lastName;
    private String email;
    private String password;
    private String phone;
    private List<Workspace> workspaces;

    public User() {}

    public User(String Id, String firstName, String lastName, String email, String password, String phone) {
        this.Id = Id;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.password = password;
        this.phone = phone;
    }

    public String getId() {
        return Id;
    }

    public void setId(String Id) {
        this.Id = Id;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
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

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    @Override
    public String toString() {
        return "User{" +
                "id='" + Id + '\'' +
                ", firstName='" + firstName + '\'' +
                ", lastName='" + lastName + '\'' +
                ", email='" + email + '\'' +
                ", password='" + password + '\'' +
                ", phone='" + phone + '\'' +
                '}';
    }

}