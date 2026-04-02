// Task Badge Test Utilities
// Add this to browser console for testing task badge functionality
import { browser } from "$app/environment";

if (browser) {
  (window as any).RuyaxTaskBadgeDebug = {
    async testTaskBadge(count = 5) {
      console.log("🧪 Testing task badge with count:", count);

      if ("setAppBadge" in navigator) {
        try {
          await (navigator as any).setAppBadge(count);
          console.log("✅ Task badge set successfully");
        } catch (error) {
          console.error("❌ Failed to set task badge:", error);
        }
      } else {
        console.warn("⚠️ App Badge API not supported");

        // Try service worker fallback
        if (
          "serviceWorker" in navigator &&
          (navigator as any).serviceWorker.controller
        ) {
          (navigator as any).serviceWorker.controller.postMessage({
            type: "UPDATE_TASK_BADGE",
            taskCount: count,
          });
          console.log("📨 Sent badge update message to service worker");
        } else {
          console.warn("⚠️ Service worker not available");
        }
      }
    },

    async clearTaskBadge() {
      console.log("🧪 Clearing task badge");

      if ("clearAppBadge" in navigator) {
        try {
          await (navigator as any).clearAppBadge();
          console.log("✅ Task badge cleared successfully");
        } catch (error) {
          console.error("❌ Failed to clear task badge:", error);
        }
      } else if (
        "serviceWorker" in navigator &&
        (navigator as any).serviceWorker.controller
      ) {
        (navigator as any).serviceWorker.controller.postMessage({
          type: "UPDATE_TASK_BADGE",
          taskCount: 0,
        });
        console.log("📨 Sent clear badge message to service worker");
      } else {
        console.warn("⚠️ No badge API or service worker available");
      }
    },

    async testTaskNotification(taskCount = 3, overdue = 1) {
      console.log("🧪 Testing task notification");

      if (
        "serviceWorker" in navigator &&
        (navigator as any).serviceWorker.controller
      ) {
        (navigator as any).serviceWorker.controller.postMessage({
          type: "TASK_NOTIFICATION",
          title: "📋 Task Update",
          body: `You have ${taskCount} tasks assigned${overdue > 0 ? ` (${overdue} overdue)` : ""}`,
          taskCount: taskCount,
          overdue: overdue,
        });
        console.log("📨 Sent task notification message to service worker");
      } else {
        console.warn("⚠️ Service worker not available");
      }
    },

    checkBadgeSupport() {
      const support = {
        appBadgeAPI: "setAppBadge" in navigator,
        clearBadgeAPI: "clearAppBadge" in navigator,
        serviceWorker: "serviceWorker" in navigator,
        serviceWorkerActive:
          "serviceWorker" in navigator &&
          !!(navigator as any).serviceWorker.controller,
        notifications: "Notification" in window,
        notificationPermission:
          "Notification" in window ? Notification.permission : "not-supported",
      };

      console.log("📋 Task Badge Support Check:", support);
      return support;
    },

    async requestNotificationPermission() {
      if ("Notification" in window) {
        const permission = await Notification.requestPermission();
        console.log("🔔 Notification permission:", permission);
        return permission;
      } else {
        console.warn("⚠️ Notifications not supported");
        return "not-supported";
      }
    },
  };

  console.log("🧪 Task Badge Debug tools available:");
  console.log(
    "  - RuyaxTaskBadgeDebug.testTaskBadge(count) - Test setting badge count",
  );
  console.log("  - RuyaxTaskBadgeDebug.clearTaskBadge() - Clear badge");
  console.log(
    "  - RuyaxTaskBadgeDebug.testTaskNotification(total, overdue) - Test task notification",
  );
  console.log(
    "  - RuyaxTaskBadgeDebug.checkBadgeSupport() - Check API support",
  );
  console.log(
    "  - RuyaxTaskBadgeDebug.requestNotificationPermission() - Request permissions",
  );
  console.log("");
  console.log("📋 Example usage:");
  console.log("  RuyaxTaskBadgeDebug.testTaskBadge(5) // Set badge to 5");
  console.log(
    "  RuyaxTaskBadgeDebug.testTaskNotification(3, 1) // 3 tasks, 1 overdue",
  );
  console.log("  RuyaxTaskBadgeDebug.clearTaskBadge() // Clear badge");
}

// Export something to make this a proper module
export const taskBadgeDebugInitialized = true;

