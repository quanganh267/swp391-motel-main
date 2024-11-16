<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="header.jsp" %>

<style>

    .content {
        flex: 1; /* Cho phép nội dung chiếm không gian còn lại */
        /*        height: 80vh;  Chiều cao 80vh cho nội dung */
        /*        overflow-y: auto;  Thêm cuộn nếu nội dung vượt quá chiều cao */
    }
    .sidebar {
        border-radius: 16px;
        background-color: #d1e8e5; /* Màu nền nhẹ hơn */
        padding: 20px; /* Thêm padding cho sidebar */
        height: auto; /* Đảm bảo chiều cao tự động */
        /* Tùy chọn: Cố định chiều cao nếu muốn */
        /* max-height: calc(100vh - 60px); */ /* Cố định chiều cao cho sidebar */
    }
    .main-content {
        flex: 1; /* Chiếm toàn bộ chiều rộng còn lại */
        padding: 20px; /* Thêm padding cho nội dung chính */
    }
</style>

<div class="site-blocks-cover inner-page-cover overlay" style="background-image: url('images/hero_bg_1.jpg');"
     data-aos="fade" data-stellar-background-ratio="0.5" data-aos="fade">
    <div class="container">
        <div class="row align-items-center justify-content-center">
            <div class="col-md-7 text-center" data-aos="fade-up" data-aos-delay="400">
                <h1 class="text-white">Profile place</h1>
                <p>You can edit your information</p>
            </div>
        </div>
    </div>
</div>

<div class="site-section">
    <div class="container">
        <div class="row">
            <div class="site-section-heading text-center mb-5 w-border col-md-6 mx-auto">
                <h2 class="mb-5">Profile</h2>
            </div>
        </div>
        <div class="row">

            <!-- Sidebar -->

            <div class="col-md-3 p-3 sidebar" style="border-radius: 16px; background-color: #f3f6f5;"> <!-- Màu nền nhẹ hơn -->
                <div class="text-center mb-4 bg-primary p-4" style="border-radius: 10px;">
                    <img src="https://static.vecteezy.com/system/resources/thumbnails/002/318/271/small_2x/user-profile-icon-free-vector.jpg" alt="Avatar" class="img-fluid rounded-circle" style="width: 100px; height: 100px;">
                    <h5 class="mt-2" style="color: black;">Hello ${account.name}</h5> <!-- Màu chữ đen -->
                </div>

                <ul class="nav flex-column nav-pills" id="profileTabs" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link" id="home-tab" href="home" role="tab" aria-controls="home-section" aria-selected="true" style="color: black;">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" id="profile-tab" data-toggle="pill" href="#profile-section" role="tab" aria-controls="profile-section" aria-selected="true" style="color: black;">Profile</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="password-tab" data-toggle="pill" href="#password-section" role="tab" aria-controls="password-section" aria-selected="false" style="color: black;">Change Password</a>
                    </li>
                </ul>
            </div>



            <!-- Content -->
            <div class="col-md-9 main-content">
                <c:if test="${not empty message}">
                    <div class="alert alert-success">
                        ${message}
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        ${error}
                    </div>
                </c:if>
                <c:if test="${not empty message_change}">
                    <div class="alert alert-success">
                        ${message_change}
                    </div>
                </c:if>
                <c:if test="${not empty error_change}">
                    <div class="alert alert-danger">
                        ${error_change}
                    </div>
                </c:if>
                <div class="tab-content" id="profileContent">
                    <!-- Profile Section -->
                    <div class="tab-pane fade show active" id="profile-section" role="tabpanel" aria-labelledby="profile-tab">

                        <form action="profile" method="POST" class="contact-form">
                            <!-- Hidden input to differentiate actions -->
                            <input type="hidden" name="action" value="updateProfile">
                             <input type="hidden" name="status" value="value="${account.status}">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="font-weight-bold" for="username">Username</label>
                                        <input type="text" id="name" class="form-control" name="name" value="${account.name}" readonly>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="font-weight-bold" for="identityId">Role</label>
                                        <input type="text" id="role" class="form-control" name="role" value="${account.role}" readonly>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="font-weight-bold" for="email">Email</label>
                                        <input type="email" id="email" class="form-control" name="email" value="${account.email}" readonly>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="font-weight-bold" for="phoneNum">Phone Number</label>
                                        <input type="text" id="phone" class="form-control" name="phone" value="${account.phone}" required>
                                    </div>
                                </div>

                            </div>



                            <div class="row form-group">
                                <div class="col-md-12">
                                    <input type="submit" value="Update Profile" class="btn btn-primary py-3 px-4">
                                </div>
                            </div>
                        </form>
                    </div>

                    <!-- Change Password Section -->
                    <div class="tab-pane fade" id="password-section" role="tabpanel" aria-labelledby="password-tab">

                        <form action="profile" method="POST">

                            <!-- Hidden input to differentiate actions -->
                            <input type="hidden" name="action" value="changePassword">
                            <div class="form-group">
                                <label class="font-weight-bold" for="currentPassword">Current Password</label>
                                <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                            </div>
                            <div class="form-group">
                                <label class="font-weight-bold" for="newPassword">New Password</label>
                                <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                            </div>
                            <div class="form-group">
                                <label class="font-weight-bold" for="confirmPassword">Confirm Password</label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                            </div>
                            <div class="row form-group">
                                <div class="col-md-6">
                                    <input type="submit" value="Update Password" class="btn btn-primary py-3 px-4">
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>

