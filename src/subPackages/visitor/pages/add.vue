<template>
	<view class="page">
		<view class="tip-bar">
			<uni-notice-bar show-icon text="访客到访需业主提前预约，到访时凭通行码进入" backgroundColor="#fff3e8" color="#ff8c42" />
		</view>

		<!-- 访客信息 -->
		<uni-section title="访客信息" type="line" />
		<uni-list :border="false">
			<uni-list-item title="访客姓名">
				<template #body>
					<uni-easyinput v-model="form.name" placeholder="请输入访客姓名" />
				</template>
			</uni-list-item>
			<uni-list-item title="手机号码">
				<template #body>
					<uni-easyinput v-model="form.phone" type="number" :maxlength="11" placeholder="请输入访客手机号" />
				</template>
			</uni-list-item>
			<uni-list-item title="车牌号码">
				<template #body>
					<uni-easyinput v-model="form.plate" placeholder="选填，驾车来访请填写" />
				</template>
			</uni-list-item>
			<uni-list-item title="同行人数">
				<template #body>
					<uni-easyinput v-model="form.count" type="number" placeholder="含访客本人" />
				</template>
			</uni-list-item>
		</uni-list>

		<!-- 到访时间 -->
		<uni-section title="到访时间" type="line" />
		<uni-list :border="false">
			<uni-list-item title="到访日期">
				<template #body>
					<uni-datetime-picker v-model="form.date" type="date" :border="false" />
				</template>
			</uni-list-item>
			<uni-list-item title="到访时段">
				<template #body>
					<view class="time-row">
						<uni-datetime-picker v-model="form.startTime" type="time" :border="false" />
						<text class="time-line">—</text>
						<uni-datetime-picker v-model="form.endTime" type="time" :border="false" />
					</view>
				</template>
			</uni-list-item>
		</uni-list>

		<!-- 备注 -->
		<uni-section title="备注" type="line" />
		<view class="remark-card">
			<uni-easyinput v-model="form.remark" type="textarea" placeholder="选填，如来访事由等" :auto-height="true" />
		</view>

		<button class="submit-btn" @tap="onSubmit">提交预约</button>
		<view class="tip-text">预约提交后需物业审核，请提前预约</view>
	</view>
</template>

<script setup lang="ts">
	import { reactive } from "vue";

	const form = reactive({
		name: "",
		phone: "",
		plate: "",
		count: "",
		date: "",
		startTime: "",
		endTime: "",
		remark: ""
	});

	function onSubmit() {
		if (!form.name || !form.phone) {
			uni.showToast({ title: "请填写访客姓名和手机号", icon: "none" });
			return;
		}
		if (!form.date || !form.startTime || !form.endTime) {
			uni.showToast({ title: "请选择到访时间", icon: "none" });
			return;
		}
		uni.showLoading({ title: "提交中..." });
		setTimeout(() => {
			uni.hideLoading();
			uni.showModal({
				title: "预约成功",
				content: "已提交访客预约，审核通过后将生成通行码并推送通知。",
				showCancel: false,
				success: () => uni.navigateBack()
			});
		}, 1000);
	}
</script>

<style lang="scss" scoped>
	.page {
		min-height: 100vh;
		background: #f5f7f6;
		padding-bottom: 60rpx;
	}

	.tip-bar {

		:deep(.uni-noticebar) {
			margin-bottom: 0rpx;
		}
	}

	.time-row {
		display: flex;
		align-items: center;
		justify-content: flex-end;

		.time-line {
			margin: 0 12rpx;
			color: #ccc;
		}
	}

	.remark-card {
		background: #fff;
		border-radius: 24rpx;
		margin: 0 24rpx;
		padding: 24rpx;
	}

	.submit-btn {
		margin: 40rpx 30rpx 0;
		background: #ff8c42;
		color: #fff;
		font-size: 32rpx;
		font-weight: 600;
		border-radius: 50rpx;
		height: 92rpx;
		line-height: 92rpx;

		&::after {
			border: none;
		}
	}

	.tip-text {
		text-align: center;
		font-size: 22rpx;
		color: #b0b0b0;
		margin-top: 20rpx;
	}
</style>