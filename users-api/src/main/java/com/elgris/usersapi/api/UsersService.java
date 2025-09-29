package com.elgris.usersapi.api;

import com.elgris.usersapi.models.User;
import com.elgris.usersapi.repository.UserRepository;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

@Service
public class UsersService {

  private final UserRepository repo;

  public UsersService(UserRepository repo) {
    this.repo = repo;
  }

  @Cacheable(value = "userByUsername", key = "#username")
  public User getByUsername(String username) {
    // Tu repositorio ya expone este método
    return repo.findOneByUsername(username);
  }
}