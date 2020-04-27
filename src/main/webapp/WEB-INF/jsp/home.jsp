<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="viewport" content="width=device-width,minimum-scale=1,maximum-scale=1,initial-scale=2,user-scalable=1" >
		<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
		<link rel="stylesheet" href="../css/font-awesome.min.css">
		<link rel="stylesheet" href="../css/style.css">
		<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
		<script src="//cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
		<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
		<script src="//cdnjs.cloudflare.com/ajax/libs/angular.js/1.6.1/angular.min.js"></script>
		<script src="//cdnjs.cloudflare.com/ajax/libs/angular-filter/0.5.17/angular-filter.min.js"></script>
		<script src="//cdnjs.cloudflare.com/ajax/libs/angular-sanitize/1.6.1/angular-sanitize.min.js"></script>
		<script src="../js/ng-file-upload.min.js"></script>
		<title>Attacking demo</title>
	</head>
	<body ng-app="myApp" ng-controller="mainController">
		<header class="mb-4">
			<div class="container">
				<nav class="navbar navbar-expand-lg navbar-light">
					<a class="navbar-brand col-12 col-lg-2" href="/" >Attacking demo</a>
					<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent"
						aria-expanded="false" aria-label="Toggle navigation">
						<span class="navbar-toggler-icon"></span>
					</button>
					<div class="collapse navbar-collapse" id="navbarSupportedContent">
						<ul class="navbar-nav mx-auto text-center">
							<li class="nav-item mr-lg-3"
								ng-class="currentPath != 'user' ? 'active' : ''">
								<a class="nav-link" href="javascript:void(0)" ng-click="currentPath = 'home'">首頁</a>
							</li>
							<li class="nav-item mr-lg-3"
								ng-class="currentPath == 'user' ? 'active' : ''">
								<a class="nav-link" href="javascript:void(0)" ng-click="currentPath = 'user'">個人資料</a>
							</li>
						</ul>
					</div>
					<div class="text-right">您是第<span style="color:blue;margin:.5rem;font-weight:bold">{{viewer}}</span>位訪客。</div>
				</nav>
			</div>
		</header>
		<article ng-show="currentPath == 'home'">
			<div class="container-fluid">
				<div class="card">
					<div class="card-body">
        				<div style="overflow-y:scroll;height:350px">
        					<div class="card" ng-repeat="chatVO in chatList | orderBy: 'messageTime'">
        						<div class="card-body">
        							<h6 class="card-subtitle mb-2 text-muted text-right">{{chatVO.userName}}</h6>
        							<div class="d-inline card-text float-right">
        								<div class="d-inline" style="font-size:.5rem;margin:.2rem">
	        								<i class="fa fa-trash fa-2x mr-2" aria-hidden="true" style="color:red;cursor:pointer" 
	        								   ng-click="deleteMessage(chatVO)"
	        								   ng-if="chatVO.userId == userId"></i>
	        								{{chatVO.messageTime | date : "MM/dd HH:mm"}}
        								</div>
        									{{chatVO.message}}
        							</div>
        						</div>
        					</div>
        				</div>
        				
						<div class="input-group">
							<textarea ng-model="message" class="form-control" rows="1" placeholder="請輸入訊息"></textarea>
								<span class="input-group-btn">
          							<button class="btn btn-secondary" type="button" ng-click="sendMessage()">送出</button>
        						</span>
						</div>
      				</div>
				</div>
			</div>
		</article>
		<section ng-show="currentPath == 'user'">
			<div class="container">
				<div class="col-md-8 offset-md-2">
					<form ng-show="!token">
					  <div class="form-group">
					    <label for="account">帳號</label>
					    <input type="text" class="form-control" id="account" placeholder="請輸入帳號"
					    		ng-model="account">
					  </div>
					  <div class="form-group">
					    <label for="password">密碼</label>
					    <input type="password" class="form-control" id="password" placeholder="請輸入密碼"
					    		ng-model="password">
					  </div>
					  <div class="form-group text-center">
					  	<button type="submit" class="btn btn-primary"  ng-click="login()">登入</button>
					  </div>
					</form>
					<form ng-show="token">
					 	<div class="form-group">
						   <img id="myImage" style="width:50%">
						</div>
						<div class="form-group">
						   <label for="userName">使用者名稱</label>
						   <input type="text" class="form-control" id="userName" placeholder="請輸入使用者名稱"
						    		ng-model="userName">
						</div>
						<div class="form-group text-center">
						   <button type="submit" class="btn btn-primary"  ng-click="updateName()">修改使用者名稱</button>
						</div>
						<div class="form-group">
						   <label for="count">目前登入次數</label>
						   <input type="text" class="form-control" id="count" disabled="true"
						    		ng-model="count">
						 </div>
						 <div class="form-group row" style="margin: 0 0">
						 <label for="count">選擇大頭貼</label>
					        <input type="file" class="btn form-control-file col-5"
					               ng-model="files"
						       	   ngf-select
					   		   	   ngf-pattern="'image/*'"
    							   ngf-accept="'image/*'">
						</div>
				        <div ng-show="files" class="form-group text-center">
				    		<label>圖片預覽</label>
				    		<img ngf-thumbnail="files" ngf-size="{width: 300, height: 300}">
				  		</div>
				   		 <div class="form-group text-center">
				    		<button class="btn btn-info" type="button" style="margin-top: 1rem"
				    				ng-click="uploadImage()">上傳</button>
					    </div>
					</form>
				</div>
			</div>
		</section>
		<script type="text/javascript">
			var app = angular.module("myApp", ['angular.filter', 'ngSanitize', 'ngFileUpload']);
			app.controller('mainController', function ($scope, $http, Upload) {
				$scope.currentPath = "home"
				$scope.viewer = 0;
				$scope.chatList = [{userId: '01', userName: 'a123', message: 'who i am', messageTime: new Date()}, 
									{userId: '02', userName: 'a456', message: 'who i am 2', messageTime: new Date()}];
				$scope.files = null;
				
				$http.get("/api/getTotalLoginCount")
				    .then(function(response) {
				    	if (response.data.errorMsg) {
				    		return alert(response.data.errorMsg);
				    	}
				    	$scope.viewer = response.data;
				    }, function(response) {
				    	alert('系統發生錯誤!');
				    });
				
				$http.get("/api/getChatList")
				    .then(function(response) {
				    	if (response.data.errorMsg) {
				    		return alert(response.data.errorMsg);
				    	}
				    	$scope.chatList = response.data;
				    }, function(response) {
				    	alert('系統發生錯誤!');
				    });
				
				$scope.sendMessage = function() {
					if (!$scope.userId) {
						$scope.currentPath = "user"
						return alert('請先登入');
					}
					if (!$scope.message) {
						return alert('請輸入訊息');
					}
				}
				
				$scope.deleteMessage = function(chatVO) {
					console.log(chatVO);
				}
				
				$scope.login = function() {
					if (!$scope.account || !$scope.password) {
						return alert('請輸入帳號與密碼');
					}
					var postData = {};
					postData.account = $scope.account;
					postData.password = $scope.password;
					$http.post("/api/login", postData)
					    .then(function(response) {
					    	if (response.data.errorMsg) {
					    		return alert(response.data.errorMsg);
					    	}
					    	$scope.token = 'loginsuccess';
					    	$scope.userId = response.data.userId;
					    	$scope.userName = response.data.userName;
					    	$scope.count = response.data.count;
					    	$http.get("/api/getImage/" + $scope.userId, {responseType: "arraybuffer"})
							    .then(function(response) {
							    	var blob = new Blob([response.data], {type: 'image/png'});
							    	var imageUrl = URL.createObjectURL(blob);
							    	$('#myImage')[0].src = imageUrl;
							    }, function(response) {
							    	alert('系統發生錯誤!');
							    });
					    }, function(response) {
					    	alert('系統發生錯誤!');
					    });
				}
				
				$scope.updateName = function() {
					if (!$scope.userName) {
						return alert('請輸入使用者名稱');
					}
					var postData = {};
					postData.userName = $scope.userName;
					$http.post("/api/updateName/" + $scope.userId, postData)
					    .then(function(response) {
					    	if (response.data.errorMsg) {
					    		return alert(response.data.errorMsg);
					    	}
					    	alert('修改成功!');
					    }, function(response) {
					    	alert('系統發生錯誤!');
					    });
					
					$http.get("/api/getImage/" + $scope.userId, {responseType: "arraybuffer"})
					    .then(function(response) {
					    	var blob = new Blob([response.data], {type: 'image/png'});
					    	var imageUrl = URL.createObjectURL(blob);
					    	$('#myImage').src = imageUrl;
					    }, function(response) {
					    	alert('系統發生錯誤!');
					    });
				}
				
				$scope.uploadImage = function() {
					if ($scope.files) {
		 		    	Upload.upload({
		 		            url: '/api/uploadImage/' + $scope.userId,
		 		            data: {file: $scope.files}
		 		        })
		 		        .then(function (response) {
		 		        	if (response.data.errorMsg) {
					    		return alert(response.data.errorMsg);
					    	}
		 		        	$scope.file = null;
		 		        	alert('上傳成功!');
		 		        	$http.get("/api/getImage/" + $scope.userId, {responseType: "arraybuffer"})
							    .then(function(response) {
							    	var blob = new Blob([response.data], {type: 'image/png'});
							    	var imageUrl = URL.createObjectURL(blob);
							    	$('#myImage')[0].src = imageUrl;
							    }, function(response) {
							    	alert('系統發生錯誤!');
							    });
		 		        }, function (resp) {
		 		        	alert('系統發生錯誤!');
		 		        });
				    }
				}
				
			});
 		</script> 
	</body>
</html>
