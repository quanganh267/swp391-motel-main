package controller.admin;

import dal.GuestDAO;
import model.Guest;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "GuestManagementServlet", urlPatterns = {"/admin/guest-management"})
public class GuestManagementServlet extends HttpServlet {

    private GuestDAO guestDAO;

    @Override
    public void init() throws ServletException {
        guestDAO = new GuestDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Guest> guests = guestDAO.getAllGuests();
        request.setAttribute("guests", guests);
        request.getRequestDispatcher("/admin/GuestManagement.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("toggleStatus".equals(action)) {
            int guestId = Integer.parseInt(request.getParameter("guestId"));
            guestDAO.toggleGuestStatus(guestId);
        } else if ("add".equals(action)) {
            // Handle add guest logic
        } else if ("edit".equals(action)) {
            // Handle edit guest logic
        }
        response.sendRedirect(request.getContextPath() + "/admin/guest-management");
    }
} 