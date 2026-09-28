<template>
	<view class="page">
		<!-- 用户信息卡片 -->
		<view class="user-card">
			<view class="avatar">
				<uni-icons type="person-filled" size="50" color="#07C160" />
			</view>
			<view class="user-info">
				<view class="nickname">
					{{ user.nickname }}
					<uni-tag :text="user.role" :type="user.role === '业主' ? 'success' : 'default'" size="small"
						:circle="true" />
				</view>
				<view class="house" v-if="user.role === '业主'" @tap="go('/pages/user/bindHouse')">🏠 {{ user.house }}
				</view>
				<view class="house guest" v-else @tap="go('/pages/user/bindHouse')">点击绑定房屋，解锁全部服务 ›</view>
			</view>
			<view class="settings-btn" @tap="go('/pages/setting/setting')">
				<uni-icons type="gear-filled" size="26" color="#ffffff" />
			</view>
		</view>

		<!-- 房屋认证卡 -->
		<view class="certify-card" v-if="user.role === '业主'" @tap="go('/pages/user/bindHouse')">
			<uni-icons type="checkmarkempty" size="24" color="#07C160" />
			<view class="certify-main">
				<view class="certify-title">业主身份已认证</view>
				<view class="certify-desc">富新社区 · {{ user.house }} · 服务有效期至 2027-12</view>
			</view>
			<uni-icons type="right" size="20" color="#ccc" />
		</view>

		<!-- 我的记录 -->
		<uni-section title="我的记录" type="line" />
		<uni-list :border="false">
			<uni-list-item v-for="item in records" :key="item.name" :title="item.name" :show-arrow="true"
				:clickable="true" :show-badge="!!item.badge" :badge-text="item.badge || ''" badge-type="error"
				@click="go(item.url)">
				<template #header>
					<view class="record-icon">{{ item.icon }}</view>
				</template>
			</uni-list-item>
		</uni-list>

		<!-- 常用功能 -->
		<uni-section title="常用功能" type="line" />
		<uni-list :border="false">
			<uni-list-item v-for="item in menus" :key="item.name" :title="item.name" :show-arrow="true"
				:clickable="true" @click="go(item.url)">
				<template #header>
					<view class="record-icon">{{ item.icon }}</view>
				</template>
			</uni-list-item>
		</uni-list>

		<!-- 退出登录 -->
		<view class="logout-btn" @tap="onLogout">退出登录</view>
		<view class="footer-space"></view>
	</view>
</template>

<script setup lang="ts">
	import { ref } from "vue";

	const user = ref({
		nickname: "小区业主",
		role: "业主",
		house: "3号楼 2单元 1201"
	});

	const records = ref([
		{ name: "我的工单", icon: "🔧", url: "/pages/repair/list" },
		{ name: "访客预约", icon: "🚪", url: "/pages/visitor/list" },
		{ name: "投票记录", icon: "🗳️", url: "/pages/vote/record" },
		{ name: "消息通知", icon: "🔔", url: "/pages/message/list", badge: "3" }
	]);

	const menus = ref([
		{ name: "意见反馈", icon: "💡", url: "/pages/feedback/add" },
		{ name: "房屋绑定", icon: "🏠", url: "/pages/user/bindHouse" },
		{ name: "系统设置", icon: "⚙️", url: "/pages/setting/setting" }
	]);

	function go(url : string) {
		uni.navigateTo({ url });
	}
	function onLogout() {
		uni.showModal({
			title: "提示",
			content: "确定要退出登录吗？",
			success: (res) => {
				if (res.confirm) {
					uni.showToast({ title: "已退出登录", icon: "none" });
					uni.reLaunch({ url: '/pages/login/login' });
				}
			}
		});
	}
</script>

<style lang="scss" scoped>
	.page {
		min-height: 100vh;
		background: #f5f7f6;
		padding-bottom: 20rpx;
	}

	.user-card {
		background: linear-gradient(135deg, #07c160, #06ad56);
		padding: 60rpx 40rpx 90rpx;
		display: flex;
		align-items: center;
		border-radius: 0 0 40rpx 40rpx;

		.avatar {
			width: 120rpx;
			height: 120rpx;
			border-radius: 50%;
			background: #fff;
			display: flex;
			align-items: center;
			justify-content: center;
			margin-right: 24rpx;
		}

		.user-info {
			flex: 1;
			min-width: 0;

			.nickname {
				font-size: 34rpx;
				font-weight: 700;
				color: #fff;
				display: flex;
				align-items: center;

				uni-tag {
					margin-left: 12rpx;
				}
			}

			.house {
				font-size: 24rpx;
				color: rgba(255, 255, 255, 0.9);
				margin-top: 12rpx;

				&.guest {
					text-decoration: underline;
				}
			}
		}

		.settings-btn {
			padding: 10rpx;
		}
	}

	.certify-card {
		margin: -50rpx 24rpx 0;
		background: #fff;
		border-radius: 24rpx;
		padding: 26rpx 30rpx;
		display: flex;
		align-items: center;

		.certify-main {
			flex: 1;
			margin-left: 16rpx;

			.certify-title {
				font-size: 28rpx;
				font-weight: 600;
				color: #333;
			}

			.certify-desc {
				font-size: 22rpx;
				color: #999;
				margin-top: 6rpx;
			}
		}
	}

	.record-icon {
		font-size: 36rpx;
		margin-right: 6rpx;
	}

	.logout-btn {
		margin: 40rpx 24rpx 0;
		background: #fff;
		border-radius: 24rpx;
		text-align: center;
		font-size: 28rpx;
		color: #ff5b4d;
		padding: 26rpx;
	}

	.footer-space {
		height: 40rpx;
	}
</style>