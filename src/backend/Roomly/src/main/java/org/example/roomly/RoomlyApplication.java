package org.example.roomly;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.jdbc.core.JdbcTemplate;

import org.example.roomly.model.*;
import org.example.roomly.repository.*;
import java.util.Date;
import java.util.Optional;
import java.util.UUID;

import java.util.Date;

@SpringBootApplication
public class RoomlyApplication {

    public static void main(String[] args) {
        SpringApplication.run(RoomlyApplication.class, args);
    }

    @Bean
    public CommandLineRunner commandLineRunner(JdbcTemplate jdbcTemplate){
        return runner ->{
            // test customer repo
            //CustomerRepository customerRepository = new CustomerRepository(jdbcTemplate);
            //testCustomerRepository(customerRepository);

            // test staff repo
            //WorkspaceStaffRepository workspaceStaffRepository = new WorkspaceStaffRepository(jdbcTemplate);
            //testWorkspaceStaffRepository(workspaceStaffRepository);

            // test request repo
            //RequestRepository requestRepository = new RequestRepository(jdbcTemplate);
            //testRequestRepository(requestRepository);

            // test preference repo
            //CustomerRepository customerRepository2 = new CustomerRepository(jdbcTemplate);
            //PreferenceRepository preferenceRepository = new PreferenceRepository(jdbcTemplate);
            //testPreferenceRepository(customerRepository2, preferenceRepository);

            // test loyalty points repo
            //CustomerRepository customerRepository3 = new CustomerRepository(jdbcTemplate);
            //LoyaltyPointsRepository loyalPointsRepository = new LoyaltyPointsRepository(jdbcTemplate);
            //testLoyalPointsRepository(customerRepository3, loyalPointsRepository);


                //saveReview(jdbcTemplate);
        };
    }
    public void saveReview(JdbcTemplate jdbcTemplate){
        System.out.println("hello");
        // write your test code
        System.out.println("saved");
    }

    public void testCustomerRepository(CustomerRepository customerRepository) {
        Customer customer = new Customer(
                UUID.randomUUID().toString(),
                "Mostafa",
                "Ali",
                "mostafa@mail.com",
                "securepassword",
                "+123456789",
                "123 Main St, NY"
        );

        // test save
        customerRepository.save(customer);
        System.out.println("✅ Customer added successfully!");

        // test find by id
        Customer foundCustomer = customerRepository.findById(customer.getUserId());
        if (foundCustomer != null) {
            System.out.println("✅ Customer found: " + foundCustomer);
        } else {
            System.out.println("❌ Customer not found!");
        }

        // test find all
        System.out.println("✅ Customers found: " + customerRepository.findAll());

        // test update
        customer.setFirstName("Darsh");
        customerRepository.update(customer);
        System.out.println("✅ Customer updated successfully!");

        Customer theCustomer = customerRepository.findById(customer.getUserId());
        if (foundCustomer != null) {
            System.out.println("✅ Customer: " + theCustomer);
        } else {
            System.out.println("❌ Customer not found!");
        }

        // test delete
        customerRepository.deleteById(customer.getUserId());
        System.out.println("✅ Customer deleted successfully!");
    }

    public void testWorkspaceStaffRepository(WorkspaceStaffRepository workspaceStaffRepository) {
        WorkspaceStaff staff = new WorkspaceStaff(
                UUID.randomUUID().toString(),
                "Oppad",
                "Nasser",
                "oppad@mail.com",
                "securepassword",
                "+123456789",
                WorkspaceStaffType.ADMIN
        );

        // test save
        workspaceStaffRepository.save(staff);
        System.out.println("✅ Staff added successfully!");

        // test find by id
        WorkspaceStaff foundStaff = workspaceStaffRepository.findById(staff.getUserId());
        if (foundStaff != null) {
            System.out.println("✅ Staff found: " + foundStaff);
        } else {
            System.out.println("❌ Staff not found!");
        }

        // test find all
        System.out.println("✅ Staffs found: " + workspaceStaffRepository.findAll());

        // test update
        staff.setFirstName("Abdel Gafour");
        workspaceStaffRepository.update(staff);
        System.out.println("✅ Staff updated successfully!");

        WorkspaceStaff theStaff = workspaceStaffRepository.findById(staff.getUserId());
        if (foundStaff != null) {
            System.out.println("✅ Staff: " + theStaff);
        } else {
            System.out.println("❌ Staff not found!");
        }

        // test delete
        workspaceStaffRepository.deleteById(staff.getUserId());
        System.out.println("✅ Staff deleted successfully!");
    }

    public void testRequestRepository(RequestRepository requestRepository) {
        Request request = new Request(
                UUID.randomUUID().toString(),
                "Customize Workspace",
                new Date(),
                // put date from future
                new Date("2022/12/12"),
                "Need to add a new desk",
                RequestStatus.PENDING,
                "Response"
        );

        // test save
        requestRepository.save(request);
        System.out.println("✅ Request added successfully!");

        // test find by id
        Optional<Request> foundRequest = requestRepository.findById(request.getRequestId());
        if (foundRequest.isPresent()) {
            System.out.println("✅ Request found: " + foundRequest);
        } else {
            System.out.println("❌ Request not found!");
        }

        // test find all
        System.out.println("✅ Requests found: " + requestRepository.findAll());

        // test update
        request.setRequestType("New Request Type");
        requestRepository.update(request);
        System.out.println("✅ Request updated successfully!");

        Optional<Request> theRequest = requestRepository.findById(request.getRequestId());
        if (foundRequest != null) {
            System.out.println("✅ Request: " + theRequest);
        } else {
            System.out.println("❌ Request not found!");
        }

        // test delete
        requestRepository.deleteById(request.getRequestId());
        System.out.println("✅ Request deleted successfully!");
    }

    public void testPreferenceRepository(CustomerRepository customerRepository, PreferenceRepository preferenceRepository) {
        Customer customer = new Customer(
                UUID.randomUUID().toString(),
                "Mohamed",
                "Mahmoud",
                "mohamed@mail.com",
                "securepassword",
                "+123456789",
                "123 Main St, NY"
        );

        // test save
        customerRepository.save(customer);
        System.out.println("✅ Customer added successfully!");

        Preference preference = new Preference(
                "Budget",
                "Workspace Type",
                customer.getUserId()
        );

        // test save
        preferenceRepository.save(preference);
        System.out.println("✅ Preference added successfully!");

        // test find by id
        Optional<Preference> foundPreference = preferenceRepository.findById(preference.getUserId());
        if (foundPreference.isPresent()) {
            System.out.println("✅ Preference found: " + foundPreference);
        } else {
            System.out.println("❌ Preference not found!");
        }

        // test find all
        System.out.println("✅ Preferences found: " + preferenceRepository.findAll());

        // test update
        preference.setBudgetPreference("New Budget");
        preferenceRepository.update(preference);
        System.out.println("✅ Preference updated successfully!");

        Optional<Preference> thePreference = preferenceRepository.findById(preference.getUserId());
        if (foundPreference.isPresent()) {
            System.out.println("✅ Preference: " + thePreference);
        } else {
            System.out.println("❌ Preference not found!");
        }

        // test delete
        preferenceRepository.deleteById(preference.getUserId());
        System.out.println("✅ Preference deleted successfully!");
    }

    public void testLoyalPointsRepository(CustomerRepository customerRepository, LoyaltyPointsRepository loyalPointsRepository) {
        Customer customer = new Customer(
                UUID.randomUUID().toString(),
                "Salma",
                "Ramadan",
                "salma@mail.com",
                "securepassword",
                "+123456789",
                "123 Main St, NY"
        );

        // test save
        customerRepository.save(customer);
        System.out.println("✅ Customer added successfully!");

        LoyaltyPoints loyalPoints = new LoyaltyPoints(
                100,
                10,
                new Date(),
                customer.getUserId()
        );

        // test save
        loyalPointsRepository.save(loyalPoints);
        System.out.println("✅ LoyaltyPoints added successfully!");

        // test find by id
        Optional<LoyaltyPoints> foundLoyalPoints = loyalPointsRepository.findById(loyalPoints.getUserId());
        if (foundLoyalPoints.isPresent()) {
            System.out.println("✅ LoyaltyPoints found: " + foundLoyalPoints);
        } else {
            System.out.println("❌ LoyaltyPoints not found!");
        }

        // test find all
        System.out.println("✅ LoyaltyPoints found: " + loyalPointsRepository.findAll());

        // test update
        loyalPoints.setTotalPoints(200);
        loyalPointsRepository.update(loyalPoints);
        System.out.println("✅ LoyaltyPoints updated successfully!");

        Optional<LoyaltyPoints> theLoyalPoints = loyalPointsRepository.findById(loyalPoints.getUserId());
        if (foundLoyalPoints.isPresent()) {
            System.out.println("✅ LoyaltyPoints: " + theLoyalPoints);
        } else {
            System.out.println("❌ LoyaltyPoints not found!");
        }

        // test delete
        loyalPointsRepository.deleteById(loyalPoints.getUserId());
        System.out.println("✅ LoyaltyPoints deleted successfully!");
    }
}
