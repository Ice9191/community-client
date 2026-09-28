<template>
	<view class="page">
		<view class="tip-bar">
			<uni-notice-bar show-icon text="绑定房屋后即可使用报修、预约、投票等业主专属服务" backgroundColor="#e8f8ef" color="#07c160" />
		</view>

		<!-- 房屋信息 -->
		<uni-section title="房屋信息" type="line" />
		<uni-list :border="false">
			<uni-list-item title="所属小区" :show-arrow="true" :clickable="true">
				<template #body>
					<picker :range="communities" @change="onCommunity">
						<view class="picker-value" :class="{ placeholder: !form.community }">
							{{ form.community || "请选择小区" }}
						</view>
					</picker>
				</template>
			</uni-list-item>
			<uni-list-item title="楼栋" :show-arrow="true" :clickable="true">
				<template #body>
					<picker :range="buildings" @change="onBuilding">
						<view class="picker-value" :class="{ placeholder: !form.building }">
							{{ form.building || "请选择楼栋" }}
						</view>
					</picker>
				</template>
			</uni-list-item>
			<uni-list-item title="单元" :show-arrow="true" :clickable="true">
				<template #body>
					<picker :range="units" @change="onUnit">
						<view class="picker-value" :class="{ placeholder: !form.unit }">
							{{ form.unit || "请选择单元" }}
						</view>
					</picker>
				</template>
			</uni-list-item>
			<uni-list-item title="房号">
				<template #body>
					<uni-easyinput v-model="form.room" placeholder="请输入房号，如 1201" />
				</template>
			</uni-list-item>
		</uni-list>

		<!-- 业主信息 -->
		<uni-section title="业主信息" type="line" />
		<uni-list :border="false">
			<uni-list-item title="业主姓名">
				<template #body>
					<uni-easyinput v-model="form.name" placeholder="请输入业主姓名" />
				</template>
			</uni-list-item>
			<uni-list-item title="手机号码">
				<template #body>
					<uni-easyinput v-model="form.phone" type="number" :maxlength="11" placeholder="请输入手机号码" />
				</template>
			</uni-list-item>
		</uni-list>

		<view class="agree-row">
			<view class="agree-box" :class="{ checked: agree }" @tap="agree = !agree">
				<uni-icons v-if="agree" type="checkmarkempty" size="14" color="#ffffff" />
			</view>
			<text class="agree-text">我已阅读并同意《业主认证协议》及《个人信息保护政策》</text>
		</view>

		<button class="submit-btn" @tap="onSubmit">提交认证</button>
		<view class="tip-text">认证信息将与物业预录入的业主信息库进行比对核验</view>
	</view>
</template>

<script setup lang="ts">
	import { reactive, ref } from "vue";

	const communities = ["富新社区·一期", "富新社区·二期", "富新社区·三期"];
	const buildings = ["1号楼", "2号楼", "3号楼", "5号楼", "6号楼"];
	const units = ["1单元", "2单元", "3单元"];

	const form = reactive({
		community: "",
		building: "",
		unit: "",
		room: "",
		name: "",
		phone: ""
	});

	const agree = ref(false);

	function onCommunity(e : any) {
		form.community = communities[e.detail.value];
	}
	function onBuilding(e : any) {
		form.building = buildings[e.detail.value];
	}
	function onUnit(e : any) {
		form.unit = units[e.detail.value];
	}

	function onSubmit() {
		if (!form.community || !form.building || !form.unit || !form.room) {
			uni.showToast({ title: "请完善房屋信息", icon: "none" });
			return;
		}
		if (!form.name || !form.phone) {
			uni.showToast({ title: "请填写业主信息", icon: "none" });
			return;
		}
		if (!agree.value) {
			uni.showToast({ title: "请先同意认证协议", icon: "none" });
			return;
		}
		uni.showLoading({ title: "核验中..." });
		setTimeout(() => {
			uni.hideLoading();
			uni.showModal({
				title: "认证成功",
				content: "恭喜！已核验为业主身份，全部服务已解锁。",
				showCancel: false,
				success: () => uni.navigateBack()
			});
		}, 1200);
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

	.picker-value {
		font-size: 28rpx;
		color: #333;
		text-align: right;

		&.placeholder {
			color: #c0c0c0;
		}
	}

	.agree-row {
		display: flex;
		align-items: flex-start;
		padding: 10rpx 30rpx;

		.agree-box {
			width: 36rpx;
			height: 36rpx;
			border-radius: 50%;
			border: 2rpx solid #ccc;
			margin-right: 16rpx;
			display: flex;
			align-items: center;
			justify-content: center;
			flex-shrink: 0;

			&.checked {
				background: #07c160;
				border-color: #07c160;
			}
		}

		.agree-text {
			font-size: 22rpx;
			color: #999;
			line-height: 1.6;
		}
	}

	.submit-btn {
		margin: 40rpx 30rpx 0;
		background: #07c160;
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