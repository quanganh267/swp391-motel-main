/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import model.enums.Role;
import model.enums.Status;
/**
 *
 * @author DLCT
 */
@WebServlet(name = "ProfileController", urlPatterns = {"/profile"})
public class ProfileController extends HttpServlet {
            UserDAO dao = new UserDAO();
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ProfileController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProfileController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }
    

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
     HttpSession session = request.getSession();
        User user = (User)session.getAttribute("account");
        if (user == null) {
            // Chuyển hướng đến trang đăng nhập nếu user chưa đăng nhập
            response.sendRedirect("login.jsp");
        } else {
            // Chuyển hướng đến trang profile.jsp
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    HttpSession session = request.getSession();

    // Lấy đối tượng User từ session
    User user = (User) session.getAttribute("account");
    if (user == null) {
        response.sendRedirect("login.jsp"); // Nếu người dùng chưa đăng nhập, chuyển hướng tới trang đăng nhập
        return;
    }

    String action = request.getParameter("action");
    
    if ("updateProfile".equals(action)) {
        // Xử lý cập nhật thông tin hồ sơ
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String name = request.getParameter("name");
        // Nếu có trường role và status cho phép chỉnh sửa, có thể thêm tương ứng vào
        String roleParam = request.getParameter("role"); // Giá trị vai trò có thể cập nhật nếu cần
//        String statusParam = request.getParameter("status"); // Giá trị trạng thái có thể cập nhật nếu cần
        // Cập nhật thông tin cho đối tượng user
        user.setEmail(email);
        user.setPhone(phone);
        user.setName(name);
        user.setId(user.getId());
        // Nếu cần, chuyển đổi giá trị role và status từ chuỗi sang enum
        if (roleParam != null) {
            Role role = Role.valueOf(roleParam.toUpperCase()); // Chuyển chuỗi sang enum Role
            user.setRole(role);
        }
//        System.out.println("status"+statusParam);
//        if (statusParam != null) {
//            Status status = Status.valueOf(statusParam.toUpperCase()); // Chuyển chuỗi sang enum Status
//            user.setStatus(status);
//            
//        }

        // Cập nhật thông tin người dùng trong cơ sở dữ liệu
        if (dao.updateUser(user)) {
            request.setAttribute("message", "Profile updated successfully!");
        } else {
            request.setAttribute("error", "Failed to update profile.");
        }

        // Cập nhật thông tin trong session
        session.setAttribute("account", user);
        request.getRequestDispatcher("profile.jsp").forward(request, response);

    } else if ("changePassword".equals(action)) {
        // Xử lý thay đổi mật khẩu
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Kiểm tra mật khẩu hiện tại
        if (user.getPassword() != null && user.getPassword().equals(currentPassword)) {
            // Kiểm tra mật khẩu mới và xác nhận mật khẩu
            if (newPassword.equals(confirmPassword)) {
                // Cập nhật mật khẩu mới
                if (dao.updatePassword(user.getEmail(), newPassword)) {
                    user.setPassword(newPassword);
                    session.setAttribute("account", user); // Cập nhật lại session
                    request.setAttribute("message", "Password changed successfully!");
                } else {
                    request.setAttribute("error", "Failed to change password.");
                }
            } else {
                request.setAttribute("error", "New password and confirm password do not match.");
            }
        } else {
            request.setAttribute("error", "Current password is incorrect or not set.");
        }

        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
}



    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
