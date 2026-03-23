package com.project.simplepetmanager.controller.view;

import com.project.simplepetmanager.model.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@RequiredArgsConstructor
public class UserViewController {

    private final UserService userService;

    @GetMapping("/user/register")
    public String registerView() {
        return "user/register";
    }

    @GetMapping("/user/login")
    public String loginView() {
        return "/user/login";
    }
}
