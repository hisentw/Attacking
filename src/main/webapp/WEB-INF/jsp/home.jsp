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
					    <label for="exampleInputEmail1">帳號</label>
					    <input type="text" class="form-control" id="exampleInputEmail1" placeholder="請輸入帳號"
					    		ng-model="account">
					  </div>
					  <div class="form-group">
					    <label for="exampleInputPassword1">密碼</label>
					    <input type="password" class="form-control" id="exampleInputPassword1" placeholder="請輸入密碼"
					    		ng-model="account">
					  </div>
					  <div style="text-align:center">
					  	<button type="submit" class="btn btn-primary">登入</button>
					  </div>
					</form>
					<form ng-show="token">
						會員資訊
					</form>
				</div>
			</div>
		</section>
		<script type="text/javascript">
			var app = angular.module("myApp", ['angular.filter', 'ngSanitize', 'ngFileUpload']);
			app.controller('mainController', function ($scope, $http) {
				$scope.currentPath = "home"
				$scope.viewer = 100;
				$scope.chatList = [{userId: '01', userName: 'a123', message: 'who i am', messageTime: new Date()}, 
									{userId: '02', userName: 'a456', message: 'who i am 2', messageTime: new Date()}];
				$scope.userId = null;
				$scope.token = null;
				
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
			});
 		</script> 
	</body>
</html>
