<template>
	<view class="login-container">
		<view class="login-title">
			<view class="app-name">富新社区</view>
			<view class="app-desc">智慧社区服务平台</view>
		</view>

		<uni-forms ref="formRef" :model="formData" :rules="rules" label-width="80" label-align="right">
			<uni-forms-item label="账号" name="username">
				<uni-easyinput v-model="formData.username" placeholder="请输入账号" />
			</uni-forms-item>

			<uni-forms-item label="密码" name="password">
				<uni-easyinput v-model="formData.password" type="password" placeholder="请输入密码" />
			</uni-forms-item>

			<uni-forms-item name="agree">
				<uni-data-checkbox v-model="formData.agree" :localdata="agreeOptions" />
			</uni-forms-item>

			<button type="primary" @click="handleSubmit" :loading="loading">登 录</button>
		</uni-forms>
	</view>
</template>

<script setup lang="ts">
	import {
		reactive,
		ref
	} from 'vue';
	import type {
		LoginFormType
	} from '@/types/types';
	import { loginApi } from '@/api/api';

	const formRef = ref<any>(null);
	const loading = ref(false);

	const agreeOptions = [{
		text: '我已阅读并同意《用户协议》',
		value: 'agree'
	}];

	const formData = reactive<LoginFormType>({
		username: '',
		password: '',
		agree: ''
	});

	const rules = {
		username: {
			rules: [{
				required: true,
				errorMessage: '请输入用户名'
			}]
		},
		password: {
			rules: [{
				required: true,
				errorMessage: '请输入密码'
			}]
		}
	};

	const handleSubmit = () => {
		if (!formData.agree) {
			uni.showToast({
				title: '请先勾选同意用户协议',
				icon: 'none'
			});
			return;
		}
		if (formRef.value) {
			formRef.value.validate()
				.then(() => doLogin())
				.catch(() => { });
		}
	}

	const doLogin = async () => {
		loading.value = true;
		const res = await loginApi(formData);
		console.log(res);
		
		uni.setStorageSync('token', res.token);
		uni.setStorageSync('user', res.user);

		uni.showToast({
			title: '登录成功',
			icon: 'success'
		});
		setTimeout(() => {
			uni.switchTab({
				url: '/pages/index/index'
			});
		}, 600);
	}
</script>

<style lang="scss" scoped>
	.login-container {
		padding: 80rpx 40rpx 40rpx;
		background: #f5f7f6;
		min-height: 100vh;
	}

	.login-title {
		text-align: center;
		margin-bottom: 60rpx;

		.app-name {
			font-size: 48rpx;
			font-weight: 700;
			color: #07C160;
		}

		.app-desc {
			margin-top: 12rpx;
			font-size: 26rpx;
			color: #999;
		}
	}

	button {
		margin-top: 40rpx;
		background: #07C160;
	}
</style>