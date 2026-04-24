// page-change.js
function switchTab(type) {
    if(type === 'user') {
        document.getElementById('userForm').style.display = 'block';
        document.getElementById('bizForm').style.display = 'none';
    } else {
        document.getElementById('userForm').style.display = 'none';
        document.getElementById('bizForm').style.display = 'block';
    }
}