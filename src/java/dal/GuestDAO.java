package dal;

import model.Guest;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class GuestDAO extends DBContext {

    public List<Guest> getAllGuests() {
        List<Guest> guests = new ArrayList<>();
        String query = "SELECT * FROM Guest";
        try {
            PreparedStatement ps = connection.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Guest guest = new Guest(
                    rs.getInt("Guest_id"),
                    rs.getString("Name"),
                    rs.getString("Email"),
                    rs.getString("PhoneNum"),
                    rs.getString("Identity_id")
                );
                guests.add(guest);
            }
        } catch (SQLException e) {
            Logger.getLogger(GuestDAO.class.getName()).log(Level.SEVERE, null, e);
        }
        return guests;
    }

    public void toggleGuestStatus(int guestId) {
        String sql = "UPDATE Guest SET Status = CASE WHEN Status = 'ACTIVE' THEN 'INACTIVE' ELSE 'ACTIVE' END WHERE Guest_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, guestId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
} 