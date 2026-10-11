<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>برنامج حماية الصور الشخصي</title>
    <style>
        * {
            box-sizing: border-box;
            font-family: Tahoma, sans-serif;
            margin: 0;
            padding: 0;
        }
        body {
            background-color: #f0f2f5;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .container {
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 500px;
            text-align: center;
        }
        h2 {
            margin-bottom: 20px;
            color: #333;
        }
        input[type="password"], input[type="file"] {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        button {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
            margin-top: 10px;
        }
        button:hover {
            background-color: #0056b3;
        }
        .error {
            color: red;
            margin-top: 10px;
            font-size: 14px;
        }
        .hidden {
            display: none;
        }
        .gallery {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
            gap: 10px;
            margin-top: 20px;
            max-height: 300px;
            overflow-y: auto;
        }
        .gallery img {
            width: 100%;
            height: 100px;
            object-fit: cover;
            border-radius: 5px;
            border: 1px solid #ddd;
        }
        .logout-btn {
            background-color: #dc3545;
            margin-top: 20px;
        }
        .logout-btn:hover {
            background-color: #bd2130;
        }
    </style>
</head>
<body>

    <div class="container">
        <!-- قسم إنشاء كلمة المرور (يظهر أول مرة فقط) -->
        <div id="setup-section" class="hidden">
            <h2>إنشاء كلمة مرور للبرنامج</h2>
            <p>برجاء إدخال كلمة مرور جديدة لحماية صورك:</p>
            <input type="password" id="new-password" placeholder="كلمة المرور الجديدة">
            <button onclick="createPassword()">حفظ كلمة المرور</button>
        </div>

        <!-- قسم تسجيل الدخول -->
        <div id="login-section" class="hidden">
            <h2>تسجيل الدخول</h2>
            <p>البرنامج محمي، أدخل كلمة المرور للمتابعة:</p>
            <input type="password" id="login-password" placeholder="كلمة المرور">
            <button onclick="checkPassword()">دخول</button>
            <div id="login-error" class="error"></div>
        </div>

        <!-- واجهة البرنامج الرئيسية (بعد الدخول الناجح) -->
        <div id="app-section" class="hidden">
            <h2>معرض الصور المحمي</h2>
            <p>اختر صوراً لإضافتها إلى البرنامج:</p>
            <input type="file" id="image-input" accept="image/*" multiple onchange="uploadImages(event)">
            
            <div class="gallery" id="image-gallery">
                <!-- الصور ستظهر هنا -->
            </div>

            <button class="logout-btn" onclick="logout()">تسجيل الخروج وإقفال البرنامج</button>
        </div>
    </div>

    <script>
        // التحقق من وجود كلمة مرور مخزنة مسبقاً عند فتح الصفحة
        window.onload = function() {
            const savedPassword = localStorage.getItem("app_password");
            if (!savedPassword) {
                document.getElementById("setup-section").classList.remove("hidden");
            } else {
                document.getElementById("login-section").classList.remove("hidden");
            }
            loadImages();
        };

        // حفظ كلمة المرور الجديدة
        function createPassword() {
            const pass = document.getElementById("new-password").value;
            if (pass.trim() === "") {
                alert("يرجى إدخال كلمة مرور صحيحة");
                return;
            }
            localStorage.setItem("app_password", pass);
            alert("تم حفظ كلمة المرور بنجاح!");
            document.getElementById("setup-section").classList.add("hidden");
            document.getElementById("login-section").classList.remove("hidden");
        }

        // التحقق من كلمة المرور عند الدخول
        function checkPassword() {
            const enteredPass = document.getElementById("login-password").value;
            const savedPass = localStorage.getItem("app_password");

            if (enteredPass === savedPass) {
                document.getElementById("login-section").classList.add("hidden");
                document.getElementById("app-section").classList.remove("hidden");
                document.getElementById("login-password").value = "";
                document.getElementById("login-error").innerText = "";
            } else {
                document.getElementById("login-error").innerText = "كلمة المرور غير صحيحة، حاول مرة أخرى.";
            }
        }

        // رفع الصور وتخزينها محلياً
        function uploadImages(event) {
            const files = event.target.files;
            let images = JSON.parse(localStorage.getItem("app_images")) || [];

            for (let i = 0; i < files.length; i++) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    images.push(e.target.result);
                    localStorage.setItem("app_images", JSON.stringify(images));
                    displayImages();
                }
                reader.readAsDataURL(files[i]);
            }
        }

        // عرض الصور المخزنة
        function loadImages() {
            displayImages();
        }

        function displayImages() {
            const gallery = document.getElementById("image-gallery");
            gallery.innerHTML = "";
            const images = JSON.parse(localStorage.getItem("app_images")) || [];

            images.forEach(src => {
                const img = document.createElement("img");
                img.src = src;
                gallery.appendChild(img);
            });
        }

        // تسجيل الخروج وإخفاء البرنامج
        function logout() {
            document.getElementById("app-section").classList.add("hidden");
            document.getElementById("login-section").classList.remove("hidden");
        }
    </script>
      