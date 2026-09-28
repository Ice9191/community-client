<template>
	<view class="page">
		<!-- 顶部主题区 -->
		<view class="hero">
			<view class="hero-title">社区服务</view>
			<view class="hero-sub">在线办理 · 进度透明 · 服务到家</view>
		</view>

		<!-- 服务入口 -->
		<view class="service-card" style="margin-bottom: 24rpx;">
			<uni-grid :column="2" :showBorder="false" :square="false" :highlight="false" @change="onServiceTap">
				<uni-grid-item v-for="(item, i) in services" :key="i" :index="i">
					<view class="service-item">
						<view class="service-icon" :style="{ background: item.bg }">{{ item.icon }}</view>
						<view class="service-info">
							<view class="service-name">{{ item.name }}</view>
							<view class="service-desc">{{ item.desc }}</view>
						</view>
						<text class="service-arrow">›</text>
					</view>
				</uni-grid-item>
			</uni-grid>
		</view>

		<!-- 进行中的投票 -->
		<view class="card" style="margin-bottom: 24rpx;">
			<uni-section title="进行中的投票" subTitle="更多" type="line" @click="go('/pages/vote/record')" />
			<view v-for="item in votes" :key="item.id" class="vote-item" @tap="goVote(item)">
				<view class="vote-head">
					<text class="vote-title">{{ item.title }}</text>
					<uni-tag :text="`${item.deadline} 截止`" type="warning" size="small" :circle="true" />
				</view>
				<progress class="vote-progress" :percent="item.percent" stroke-width="5" activeColor="#07C160"
					backgroundColor="#E8ECEA" border-radius="5" />
				<view class="vote-foot">
					<text class="vote-count">🗳️ {{ item.count }} 人已参与</text>
					<text class="vote-btn">去投票 ›</text>
				</view>
			</view>
		</view>

		<!-- 我的服务进度 -->
		<view class="card">
			<uni-list :border="false" style="margin: 0rpx 24rpx 24rpx 24rpx;">
				<uni-section title="我的服务进度" subTitle="全部" type="line" @click="go('/pages/repair/list')" />
				<uni-list-item v-for="item in todos" :key="item.id" :clickable="true" :show-arrow="true"
					@click="go('/pages/repair/list')">
					<template #header>
						<view class="todo-icon" :style="{ background: item.bg }">{{ item.icon }}</view>
					</template>
					<template #body>
						<view class="todo-main">
							<view class="todo-title">{{ item.title }}</view>
							<view class="todo-time">{{ item.time }}</view>
						</view>
					</template>
					<template #footer>
						<uni-tag :text="item.status" :type="item.tagType" size="small" :inverted="true" />
					</template>
				</uni-list-item>
			</uni-list>
		</view>

		<view class="footer-space"></view>
	</view>
</template>

<script setup lang="ts">
	import { ref } from "vue";

	interface ServiceItem {
		name : string;
		desc : string;
		icon : string;
		bg : string;
		url : string;
	}
	interface VoteItem {
		id : number;
		title : string;
		deadline : string;
		count : number;
		percent : number;
	}

	const services = ref<ServiceItem[]>([
		{ name: "物业报修", desc: "水电气 · 公共设施", icon: "🔧", bg: "#E8F8EF", url: "/pages/repair/add" },
		{ name: "访客预约", desc: "一键生成通行码", icon: "🚪", bg: "#FFF3E8", url: "/pages/visitor/add" },
		{ name: "意见征集", desc: "有建议 · 尽管说", icon: "💡", bg: "#FFF8E1", url: "/pages/feedback/add" },
		{ name: "社区投票", desc: "小区事务我参与", icon: "🗳️", bg: "#EDEFFB", url: "/pages/vote/record" }
	]);

	const votes = ref<VoteItem[]>([
		{ id: 1, title: "小区东门智能门禁改造方案投票", deadline: "09-05", count: 128, percent: 68 },
		{ id: 2, title: "公共区域增设电动车充电桩选址", deadline: "09-10", count: 86, percent: 45 },
		{ id: 3, title: "物业费缴纳方式线上化意见征集", deadline: "09-12", count: 53, percent: 30 }
	]);

	const todos = ref([
		{ id: 1, icon: "🔧", bg: "#E8F8EF", title: "厨房水管漏水报修", time: "08-26 14:30 提交", status: "处理中", tagType: "warning" },
		{ id: 2, icon: "🚪", bg: "#FFF3E8", title: "访客王先生到访预约", time: "08-26 16:00 到访", status: "已通过", tagType: "success" },
		{ id: 3, icon: "🗳️", bg: "#EDEFFB", title: "东门门禁改造方案投票", time: "08-25 参与", status: "已完成", tagType: "default" }
	]);

	function go(url : string) {
		uni.navigateTo({ url });
	}
	function onServiceTap(e : any) {
		const item = services.value[e.detail.index];
		uni.navigateTo({ url: item.url });
	}
	function goVote(item : VoteItem) {
		uni.navigateTo({ url: `/pages/vote/detail?id=${item.id}` });
	}
</script>

<style lang="scss" scoped>
	.page {
		min-height: 100vh;
		background: #f5f7f6;
		padding-bottom: 40rpx;
	}

	.hero {
		background: linear-gradient(135deg, #07c160, #06ad56);
		padding: 40rpx 40rpx 80rpx;
		border-radius: 0 0 40rpx 40rpx;

		.hero-title {
			color: #fff;
			font-size: 40rpx;
			font-weight: 700;
		}

		.hero-sub {
			color: rgba(255, 255, 255, 0.85);
			font-size: 24rpx;
			margin-top: 8rpx;
		}
	}

	.service-card {
		margin: -40rpx 24rpx 0;
		background: #fff;
		border-radius: 24rpx;
		padding: 20rpx 0 10rpx;

		.service-item {
			display: flex;
			align-items: center;
			padding: 20rpx 30rpx;

			.service-icon {
				width: 88rpx;
				height: 88rpx;
				border-radius: 24rpx;
				display: flex;
				align-items: center;
				justify-content: center;
				font-size: 44rpx;
				margin-right: 24rpx;
			}

			.service-info {
				flex: 1;

				.service-name {
					font-size: 30rpx;
					font-weight: 600;
					color: #333;
				}

				.service-desc {
					font-size: 22rpx;
					color: #999;
					margin-top: 6rpx;
				}
			}

			.service-arrow {
				font-size: 40rpx;
				color: #ccc;
			}
		}
	}

	.card {
		background: #fff;
		border-radius: 24rpx;
		margin: 0 24rpx;
		padding: 24rpx;

		.vote-item {
			background: #f8faf9;
			border-radius: 20rpx;
			padding: 24rpx;
			margin-bottom: 20rpx;

			&:last-child {
				margin-bottom: 0;
			}

			.vote-head {
				display: flex;
				justify-content: space-between;
				align-items: center;

				.vote-title {
					flex: 1;
					font-size: 28rpx;
					color: #333;
					font-weight: 500;
					margin-right: 16rpx;
				}
			}

			.vote-progress {
				margin-top: 20rpx;
			}

			.vote-foot {
				display: flex;
				justify-content: space-between;
				align-items: center;
				margin-top: 14rpx;

				.vote-count {
					font-size: 22rpx;
					color: #b0b0b0;
				}

				.vote-btn {
					font-size: 24rpx;
					color: #07c160;
					font-weight: 500;
				}
			}
		}
	}

	.todo-icon {
		width: 72rpx;
		height: 72rpx;
		border-radius: 20rpx;
		display: flex;
		align-items: center;
		justify-content: center;
		font-size: 36rpx;
		margin-right: 4rpx;
	}

	.todo-main {
		.todo-title {
			font-size: 28rpx;
			color: #333;
		}

		.todo-time {
			font-size: 22rpx;
			color: #b0b0b0;
			margin-top: 6rpx;
		}
	}

	.footer-space {
		height: 40rpx;
	}
</style>