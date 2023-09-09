#pragma once

extern VkAllocationCallbacks*   g_Allocator;
extern VkInstance               g_Instance;
extern VkPhysicalDevice         g_PhysicalDevice;
extern VkDevice                 g_Device;
extern uint32_t                 g_QueueFamily;
extern VkQueue                  g_Queue;
extern VkDebugReportCallbackEXT g_DebugReport;
extern VkPipelineCache          g_PipelineCache;
extern VkDescriptorPool         g_DescriptorPool;

extern ImGui_ImplVulkanH_Window g_MainWindowData;
extern int                      g_MinImageCount;
extern bool                     g_SwapChainRebuild;

static inline void check_vk_result(VkResult err)
{
    if (err == 0)
        return;
    fprintf(stderr, "[vulkan] Error: VkResult = %d\n", err);
    if (err < 0)
        abort();
}


void SetupVulkan(ImVector<const char*> instance_extensions);
void SetupVulkanWindow(ImGui_ImplVulkanH_Window* wd, VkSurfaceKHR surface, int width, int height);

void CleanupVulkan();
void CleanupVulkanWindow();
