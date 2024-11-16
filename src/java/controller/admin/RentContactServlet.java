package controller.admin;

import dal.RentContactDAO;
import model.RentContact;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "RentContactManagement", urlPatterns = {"/admin/rent-contact"})
public class RentContactServlet extends HttpServlet {

    private RentContactDAO rentContactDAO = new RentContactDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<RentContact> rentContacts = rentContactDAO.getAllRentContacts();
        request.setAttribute("rentContacts", rentContacts);
        request.getRequestDispatcher("/admin/rent-contact.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve parameters from the request
        int rentContractId = Integer.parseInt(request.getParameter("rentContractId"));
        String status = request.getParameter("Status");

        // Update the status in the database
        rentContactDAO.updateRentContactStatus(rentContractId, status);

        // Redirect back to the rent contact management page
        response.sendRedirect(request.getContextPath() + "/admin/rent-contact");
    }
}
