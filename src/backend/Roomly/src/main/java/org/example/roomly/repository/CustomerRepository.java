package org.example.roomly.repository;

import org.example.roomly.model.Customer;
import java.util.List;

public interface CustomerRepository {
    void save(Customer customer);
    Customer findById(String id);
    Customer findByEmail(String email);
    List<Customer> findAll();
    void update(Customer customer);
    void deleteById(String id);
    boolean existsByEmail(String email);
}