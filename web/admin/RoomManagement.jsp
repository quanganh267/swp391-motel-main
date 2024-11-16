<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="header.jsp"></jsp:include>
<div id="content-wrapper" class="d-flex flex-column">
    <div id="content">
        <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">
            <h1 class="h3 mb-2 text-gray-800">Room Management</h1>
            <ul class="navbar-nav ml-auto">
                <li class="nav-item dropdown no-arrow">
                    <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
                       data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <span class="mr-2 d-none d-lg-inline text-gray-600 small">${accounts.username}</span>
                        <img class="img-profile rounded-circle" src="${pageContext.request.contextPath}/admin/img/undraw_profile.svg">
                    </a>
                    <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in"
                         aria-labelledby="userDropdown">
                        <a class="dropdown-item" href="#">
                            <i class="fas fa-user fa-sm fa-fw mr-2 text-gray-400"></i>
                            Profile
                        </a>
                        <div class="dropdown-divider"></div>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/logout" data-toggle="modal" data-target="#logoutModal">
                            <i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
                            Logout
                        </a>
                    </div>
                </li>
            </ul>
        </nav>

        <div class="container-fluid">
            <c:if test="${not empty sessionScope.notification}">
                <div class="alert alert-success alert-dismissible fade show" role="alert" style="text-align: center">
                    ${sessionScope.notification}
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <%
                    // Clear the notification after displaying it
                    session.removeAttribute("notification");
                %>
            </c:if>

            <c:if test="${not empty sessionScope.notificationErr}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert" style="text-align: center">
                    ${sessionScope.notificationErr}
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <%
                    // Clear the notification after displaying it
                    session.removeAttribute("notificationErr");
                %>
            </c:if>

            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <button class="btn btn-primary" onclick="openAddRoomModal()">Add New Room</button>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered" width="100%" cellspacing="0">
                            <thead>
                                <tr>
                                    <th>Room ID</th>
                                    <th>Motel Name</th>
                                    <th>Room Type</th>
                                    <th>Image</th>
                                    <th>Actions</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="room" items="${rooms}">
                                    <tr id="room-${room.roomId}">
                                        <td><c:out value="${room.roomId}" /></td>
                                        <td><c:out value="${room.motelName}" /></td>
                                        <td><c:out value="${room.typeName}" /></td>
                                        <td><img src="<c:out value='${room.imageUrl}' />" alt="Room Image" width="100" /></td>
                                        <td>
                                            <button class="btn btn-warning btn-sm" onclick="openEditModal(${room.roomId}, '${room.imageUrl}', ${room.typeId}, '${room.status}', ${room.price})">Edit</button>
                                            <form action="<%= request.getContextPath() %>/admin/room-management" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this room?');">
                                                <input type="hidden" name="action" value="delete"/>
                                                <input type="hidden" name="roomId" value="${room.roomId}"/>
                                                <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                            </form>
                                        </td>
                                        <td>
                                            <form action="<%= request.getContextPath() %>/admin/room-management" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="changeStatus"/>
                                                <input type="hidden" name="roomId" value="${room.roomId}" />
                                                <label>
                                                    <input type="radio" name="newStatus" value="Available" <c:if test="${room.status == 'Available'}">checked</c:if> onchange="this.form.submit();" /> Available
                                                </label>
                                                <label>
                                                    <input type="radio" name="newStatus" value="Not Available" <c:if test="${room.status == 'Not Available'}">checked</c:if> onchange="this.form.submit();" /> Not Available
                                                </label>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Edit Modal -->
<div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="editModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form id="editForm" action="<%= request.getContextPath() %>/admin/room-management" method="post">
                <div class="modal-header">
                    <h5 class="modal-title" id="editModalLabel">Edit Room</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="action" value="edit"/>
                    <input type="hidden" name="roomId" id="editRoomId"/>
                    <div class="form-group">
                        <label for="editImageUrl">Image URL</label>
                        <input type="text" class="form-control" id="editImageUrl" name="imageUrl" required>
                    </div>
                    <div class="form-group">
                        <label for="editTypeId">Type ID</label>
                        <input type="number" class="form-control" id="editTypeId" name="typeId" required>
                    </div>
                    <div class="form-group">
                        <label for="editStatus">Status</label>
                        <input type="text" class="form-control" id="editStatus" name="status" required>
                    </div>
                    <div class="form-group">
                        <label for="editPrice">Price</label>
                        <input type="number" class="form-control" id="editPrice" name="price" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary">Save changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Add Room Modal -->
<div class="modal fade" id="addRoomModal" tabindex="-1" role="dialog" aria-labelledby="addRoomModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form id="addRoomForm" action="<%= request.getContextPath() %>/admin/room-management" method="post" class="needs-validation" novalidate>
                <div class="modal-header">
                    <h5 class="modal-title" id="addRoomModalLabel">Add New Room</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="action" value="add"/>
                    <div class="form-group">
                        <label for="addRoomId">Room ID</label>
                        <input type="number" class="form-control" id="addRoomId" name="roomId" required min="1">
                        <div class="invalid-feedback">Please enter a valid Room ID.</div>
                    </div>
                    <div class="form-group">
                        <label for="addMotelId">Motel ID</label>
                        <input type="number" class="form-control" id="addMotelId" name="motelId" required min="1">
                        <div class="invalid-feedback">Please enter a valid Motel ID.</div>
                    </div>
                    <div class="form-group">
                        <label for="addTypeId">Type ID</label>
                        <input type="number" class="form-control" id="addTypeId" name="typeId" required min="1">
                        <div class="invalid-feedback">Please enter a valid Type ID.</div>
                    </div>
                   <div class="form-group">
                        <label for="editImageUrl">Image URL</label>
                        <input type="text" class="form-control" id="editImageUrl" name="imageUrl" required>
                    </div>
                    <div class="form-group">
                        <label for="addMotelName">Motel Name</label>
                        <input type="text" class="form-control" id="addMotelName" name="motelName" required pattern="[A-Za-z\s]+" title="Only letters and spaces are allowed">
                        <div class="invalid-feedback">Please enter a valid Motel Name.</div>
                    </div>
                    <div class="form-group">
                        <label for="addTypeName">Type Name</label>
                        <input type="text" class="form-control" id="addTypeName" name="typeName" required pattern="[A-Za-z\s]+" title="Only letters and spaces are allowed">
                        <div class="invalid-feedback">Please enter a valid Type Name.</div>
                    </div>
                    <div class="form-group">
                        <label for="editStatus">Status</label>
                        <select class="form-control" id="editStatus" name="status" required>
                            <option value="Available">Available</option>
                            <option value="Not Available">Not Available</option>
                        </select>
                        <div class="invalid-feedback">Please select a status.</div>
                    </div>
                    <div class="form-group">
                        <label for="addPrice">Price</label>
                        <input type="number" class="form-control" id="addPrice" name="Price" required min="0" step="0.01">
                        <div class="invalid-feedback">Please enter a valid price.</div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary">Add Room</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp"></jsp:include>

<script>
    function openEditModal(roomId, imageUrl, typeId, status, price) {
        document.getElementById('editRoomId').value = roomId;
        document.getElementById('editImageUrl').value = imageUrl;
        document.getElementById('editTypeId').value = typeId;
        document.getElementById('editStatus').value = status;
        document.getElementById('editPrice').value = price;
        $('#editModal').modal('show');
    }

    function deleteRoom(roomId) {
        if (confirm('Are you sure you want to delete this room?')) {
            fetch(`<%= request.getContextPath() %>/admin/room-management?action=delete&roomId=${roomId}`, {
                method: 'POST'
            })
            .then(response => {
                if (response.ok) {
                    document.getElementById(`room-${roomId}`).remove();
                } else {
                    alert('Failed to delete room.');
                }
            })
            .catch(error => console.error('Error:', error));
        }
    }

    // Function to open the Add Room Modal
    function openAddRoomModal() {
        $('#addRoomModal').modal('show');
    }

    // JavaScript for disabling form submissions if there are invalid fields
    (function() {
        'use strict';
        window.addEventListener('load', function() {
            var forms = document.getElementsByClassName('needs-validation');
            var validation = Array.prototype.filter.call(forms, function(form) {
                form.addEventListener('submit', function(event) {
                    if (form.checkValidity() === false) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        }, false);
    })();
</script> 