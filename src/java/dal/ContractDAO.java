package dal;

import model.Contract;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Motel;
import model.Room;
import model.User;

public class ContractDAO extends DBContext {

    final MotelDAO motelDAO = new MotelDAO();
    final RoomDAO roomDAO = new RoomDAO();
    final UserDAO userDAO = new UserDAO();

    public List<Contract> getAllContracts() {
        List<Contract> contracts = new ArrayList<>();
        String sql = "SELECT * FROM Contract";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Contract contract = new Contract();
                contract.setId(rs.getInt("Contract_id"));
                Room room = roomDAO.getRoomsById(rs.getInt("Room_id"));
                contract.setRoom(room);
                User user = userDAO.getUserById(rs.getInt("User_ID"));
                contract.setUser(user);
                Motel motel = motelDAO.getAllMotelById(rs.getInt("motel_id"));
                contract.setMotel(motel);
                contract.setTotalPrice(rs.getDouble("Total_Price"));
                contract.setCreateAt(rs.getDate("CreateAt"));
                contract.setPaymentMethod(rs.getString("Payment_method"));
                contract.setPaymentStatus(rs.getString("Payment_Status"));
                contract.setPaymentDate(rs.getDate("Payment_Date"));
                contract.setTypeOfContract(rs.getString("TypeOfContract"));

                contracts.add(contract);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return contracts;
    }

    public boolean insertContract(Contract contract) {
        String sql = "INSERT INTO Contract (Room_id, User_ID, motel_id, Total_Price, CreateAt, Payment_method, Payment_Status, Payment_Date, TypeOfContract) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contract.getRoom().getMotelId());
            ps.setInt(2, contract.getUser().getId());
            ps.setInt(3, contract.getMotel().getMotelId());
            ps.setDouble(4, contract.getTotalPrice());
            ps.setDate(5, new java.sql.Date(System.currentTimeMillis()));
            ps.setString(6, contract.getPaymentMethod());
            ps.setString(7, contract.getPaymentStatus());
            ps.setDate(8, new java.sql.Date(contract.getPaymentDate().getTime()));
            ps.setString(9, contract.getTypeOfContract());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateContract(Contract contract) {
        String sql = "UPDATE Contract SET Room_id = ?, User_ID = ?, motel_id = ?, Total_Price = ?, CreateAt = ?, Payment_method = ?, Payment_Status = ?, Payment_Date = ?, TypeOfContract = ? WHERE Contract_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contract.getRoom().getMotelId());
            ps.setInt(2, contract.getUser().getId());
            ps.setInt(3, contract.getMotel().getMotelId());
            ps.setDouble(4, contract.getTotalPrice());
            ps.setDate(5, new java.sql.Date(contract.getCreateAt().getTime()));
            ps.setString(6, contract.getPaymentMethod());
            ps.setString(7, contract.getPaymentStatus());
            ps.setDate(8, new java.sql.Date(contract.getPaymentDate().getTime()));
            ps.setString(9, contract.getTypeOfContract());
            ps.setInt(10, contract.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteContract(int contractId) {
        String sql = "DELETE FROM Contract WHERE Contract_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Contract getContractById(int contractId) {
        String sql = "SELECT * FROM Contract WHERE Contract_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Contract contract = new Contract();
                    contract.setId(rs.getInt("Contract_id"));
                    Room room = roomDAO.getRoomsById(rs.getInt("Room_id"));
                    contract.setRoom(room);
                    User user = userDAO.getUserById(rs.getInt("User_ID"));
                    contract.setUser(user);
                    Motel motel = motelDAO.getAllMotelById(rs.getInt("motel_id"));
                    contract.setMotel(motel);
                    contract.setTotalPrice(rs.getDouble("Total_Price"));
                    contract.setCreateAt(rs.getDate("CreateAt"));
                    contract.setPaymentMethod(rs.getString("Payment_method"));
                    contract.setPaymentStatus(rs.getString("Payment_Status"));
                    contract.setPaymentDate(rs.getDate("Payment_Date"));
                    contract.setTypeOfContract(rs.getString("TypeOfContract"));

                    return contract;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Contract> Paging(List<Contract> contracts, int page, int pageSize) {
        int fromIndex = (page - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, contracts.size());

        if (fromIndex > toIndex) {
            fromIndex = toIndex;
        }

        return contracts.subList(fromIndex, toIndex);
    }

    public boolean isContractUnique(int roomId, int userId, int motelId) {
        String sql = "SELECT COUNT(*) FROM Contract WHERE Room_id = ? AND User_ID = ? AND Motel_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setInt(2, userId);
            ps.setInt(3, motelId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return false;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return true;
    }
}