import pandas as pd
import json
import matplotlib.pyplot as plt
import numpy as np

baseline_get = json.load(open("baseline-get.json"))
baseline_set = json.load(open("baseline-set.json"))
request_access = json.load(open("requestAccess.json"))
verify_access = json.load(open("verifyAccess.json"))

baseline_get_transactions_per_block = []
baseline_get_gas_used_per_block = []
baseline_get_size_growth = []
baseline_get_block_size = []
size_tmp = 0
for key in baseline_get["blocks"].keys():
    baseline_get_transactions_per_block.append(baseline_get["blocks"][key]["transactions"])
    baseline_get_gas_used_per_block.append(baseline_get["blocks"][key]["gasUsed"])
    baseline_get_block_size.append(baseline_get["blocks"][key]["size"])
    size_tmp += baseline_get["blocks"][key]["size"]
    baseline_get_size_growth.append(size_tmp)
    # print(baseline_get_transactions_per_block)

baseline_set_transactions_per_block = []
baseline_set_gas_used_per_block = []
baseline_set_size_growth = []
baseline_set_block_size = []
size_tmp = 0
for key in baseline_set["blocks"].keys():
    baseline_set_transactions_per_block.append(baseline_set["blocks"][key]["transactions"])
    baseline_set_gas_used_per_block.append(baseline_set["blocks"][key]["gasUsed"])
    baseline_set_block_size.append(baseline_set["blocks"][key]["size"])
    size_tmp += baseline_set["blocks"][key]["size"]
    baseline_set_size_growth.append(size_tmp)
    # print(baseline_set_transactions_per_block)


request_access_transactions_per_block = []
request_access_gas_used_per_block = []
request_access_size_growth = []
request_access_block_size = []
size_tmp = 0
for key in request_access["blocks"].keys():
    request_access_transactions_per_block.append(request_access["blocks"][key]["transactions"])
    request_access_gas_used_per_block.append(request_access["blocks"][key]["gasUsed"])
    request_access_block_size.append(request_access["blocks"][key]["size"])
    size_tmp += request_access["blocks"][key]["size"]
    request_access_size_growth.append(size_tmp)
    # print(request_access_transactions_per_block)

verify_access_transactions_per_block = []
verify_access_gas_used_per_block = []
verify_access_size_growth = []
verify_access_block_size = []
size_tmp = 0
for key in verify_access["blocks"].keys():
    verify_access_transactions_per_block.append(verify_access["blocks"][key]["transactions"])
    verify_access_gas_used_per_block.append(verify_access["blocks"][key]["gasUsed"])
    verify_access_block_size.append(verify_access["blocks"][key]["size"])
    size_tmp += verify_access["blocks"][key]["size"]
    verify_access_size_growth.append(size_tmp)
    # print(verify_access_transactions_per_block)


############## plot 1
# plt.plot(baseline_get_transactions_per_block[2:-2], label="Baseline contract | get")
# plt.plot(baseline_set_transactions_per_block[2:-2], label="Baseline contract | set")
# plt.plot(request_access_transactions_per_block[2:-2], label="Smart Access | Request Access")
# plt.plot(verify_access_transactions_per_block[2:-2], label="Smart Access | Verify Access")
# plt.legend(loc="upper right")
# plt.ylim(175, 300)
# plt.tight_layout()
# plt.title('Transactions per block')
# plt.xlabel('Block number')
# plt.ylabel('transactions')
# plt.show()


############# plot 2
# baseline_get_size_growth = [x / (1024*1024) for x in baseline_get_size_growth]
# baseline_set_size_growth = [x / (1024*1024) for x in baseline_set_size_growth]
# request_access_size_growth = [ x / (1024*1024) for x in request_access_size_growth]
# verify_access_size_growth = [ x / (1024*1024) for x in verify_access_size_growth]
# plt.plot(baseline_get_size_growth, label="Baseline contract | get")
# plt.plot(baseline_set_size_growth, label="Baseline contract | set")
# plt.plot(request_access_size_growth, label="Smart Access | Request Access")
# plt.plot(verify_access_size_growth, label="Smart Access | Verify Access")
# plt.legend(loc="upper left")
# plt.tight_layout()
# plt.title('Blockchain growth')
# plt.xlabel('Block number')
# plt.ylabel('Size (MB)')
# plt.show()


############# plot 3
# baseline_get_block_size = [x / (1024*1024) for x in baseline_get_block_size]
# baseline_set_block_size = [x / (1024*1024) for x in baseline_set_block_size]
# request_access_block_size = [ x / (1024*1024) for x in request_access_block_size]
# verify_access_block_size = [ x / (1024*1024) for x in verify_access_block_size]
# plt.plot(baseline_get_block_size[2:-2], label="Baseline contract | get")
# plt.plot(baseline_set_block_size[2:-2], label="Baseline contract | set" )
# plt.plot(request_access_block_size[2:-2], label="Smart Access | Request Access")
# plt.plot(verify_access_block_size[2:-2], label="Smart Access | Verify Access")
# plt.legend(loc="upper right")
# plt.ylim(0.00, 0.14)
# plt.tight_layout()
# plt.title('Quantity of data generated per block')
# plt.xlabel('Block number')
# plt.ylabel('Block size (MB)')
# plt.show()


############## plot 4
# fig, ax = plt.subplots()
# columns = [baseline_get_transactions_per_block[2:-2], baseline_set_transactions_per_block[2:-2], request_access_transactions_per_block[2:-2], verify_access_transactions_per_block[2:-2]]
# bp1 = ax.boxplot(baseline_get_transactions_per_block, positions=[1], notch=True, widths=0.35,
#                  patch_artist=True, boxprops=dict(facecolor="C0"))
# bp2 = ax.boxplot(baseline_set_transactions_per_block, positions=[2], notch=True, widths=0.35,
#                  patch_artist=True, boxprops=dict(facecolor="C1"))
# bp3 = ax.boxplot(request_access_transactions_per_block, positions=[3], notch=True, widths=0.35,
#                  patch_artist=True, boxprops=dict(facecolor="C2"))
# bp4 = ax.boxplot(verify_access_transactions_per_block, positions=[4], notch=True, widths=0.35,
#                  patch_artist=True, boxprops=dict(facecolor="C3"))                 
# plt.legend(loc="upper right")
# plt.ylim(150, 350)
# plt.tight_layout()
# plt.title('Transactions per second')
# # plt.xlabel('Block number')
# plt.ylabel('Transactions')
# ax.legend([bp1["boxes"][0], bp2["boxes"][0], bp3["boxes"][0], bp4["boxes"][0]], ['Baseline contract | get', 'Baseline contract | set', "Smart Access | Request Access", "Smart Access | Verify Access"], loc='upper right')
# plt.show()


############## plot 5
# fig, ax = plt.subplots()
# columns = [baseline_get_transactions_per_block[2:-2], baseline_set_transactions_per_block[2:-2], request_access_transactions_per_block[2:-2], verify_access_transactions_per_block[2:-2]]
# bp1 = ax.boxplot(baseline_get["latency"], positions=[1], notch=True, widths=0.35,
#                  patch_artist=True, boxprops=dict(facecolor="C0"))
# bp2 = ax.boxplot(baseline_set["latency"], positions=[2], notch=True, widths=0.35,
#                  patch_artist=True, boxprops=dict(facecolor="C1"))
# bp3 = ax.boxplot(request_access["latency"], positions=[3], notch=True, widths=0.35,
#                  patch_artist=True, boxprops=dict(facecolor="C2"))
# bp4 = ax.boxplot(verify_access["latency"], positions=[4], notch=True, widths=0.35,
#                  patch_artist=True, boxprops=dict(facecolor="C3"))                 
# plt.legend(loc="upper right")
# plt.ylim(0.5, 3.5)
# plt.tight_layout()
# plt.title('Latency')
# # plt.xlabel('Block number')
# plt.ylabel('Blocks')
# ax.legend([bp1["boxes"][0], bp2["boxes"][0], bp3["boxes"][0], bp4["boxes"][0]], ['Baseline contract | get', 'Baseline contract | set', "Smart Access | Request Access", "Smart Access | Verify Access"], loc='upper right')
# plt.show()

############## plot 6
# baseline_get_gas_used = []
# baseline_set_gas_used = []
# request_access_gas_used = []
# verify_access_gas_used  = []

# for key in baseline_get["blocks"].keys():
#     baseline_get_gas_used.append(baseline_get["blocks"][key]["gasUsed"])

# for key in baseline_set["blocks"].keys():
#     baseline_set_gas_used.append(baseline_set["blocks"][key]["gasUsed"])

# for key in request_access["blocks"].keys():
#     request_access_gas_used.append(request_access["blocks"][key]["gasUsed"])

# for key in verify_access["blocks"].keys():
#     verify_access_gas_used.append(verify_access["blocks"][key]["gasUsed"])

# fig, ax = plt.subplots()
# bp1 = ax.boxplot(baseline_get_gas_used, positions=[1], notch=True, widths=0.35,
#                  patch_artist=True, boxprops=dict(facecolor="C0"))
# bp2 = ax.boxplot(baseline_set_gas_used, positions=[2], notch=True, widths=0.35,
#                  patch_artist=True, boxprops=dict(facecolor="C1"))
# bp3 = ax.boxplot(request_access_gas_used, positions=[3], notch=True, widths=0.35,
#                  patch_artist=True, boxprops=dict(facecolor="C2"))
# bp4 = ax.boxplot(verify_access_gas_used, positions=[4], notch=True, widths=0.35,
#                  patch_artist=True, boxprops=dict(facecolor="C3"))                 
# plt.legend(loc="upper right")
# # plt.ylim(0.5, 3.5)
# plt.tight_layout()
# plt.title('Gas used to mine block')
# # plt.xlabel('Block number')
# plt.ylabel('Gas amount')
# ax.legend([bp1["boxes"][0], bp2["boxes"][0], bp3["boxes"][0], bp4["boxes"][0]], ['Baseline contract | get', 'Baseline contract | set', "Smart Access | Request Access", "Smart Access | Verify Access"], loc='upper right')
# plt.show()


############### plot 7 
fig, ax = plt.subplots()
bp1 = ax.boxplot(baseline_get["transactions"]["gasUsed"], positions=[1], notch=True, widths=0.35,
                 patch_artist=True, boxprops=dict(facecolor="C0"))
bp2 = ax.boxplot(baseline_set["transactions"]["gasUsed"], positions=[2], notch=True, widths=0.35,
                 patch_artist=True, boxprops=dict(facecolor="C1"))
bp3 = ax.boxplot(request_access["transactions"]["gasUsed"], positions=[3], notch=True, widths=0.35,
                 patch_artist=True, boxprops=dict(facecolor="C2"))
bp4 = ax.boxplot(verify_access["transactions"]["gasUsed"], positions=[4], notch=True, widths=0.35,
                 patch_artist=True, boxprops=dict(facecolor="C3"))                 
plt.legend(loc="upper right")
# plt.ylim(0.5, 3.5)
plt.tight_layout()
plt.title('Gas used per transaction')
# plt.xlabel('Block number')
plt.ylabel('Gas amount')
ax.legend([bp1["boxes"][0], bp2["boxes"][0], bp3["boxes"][0], bp4["boxes"][0]], ['Baseline contract | get', 'Baseline contract | set', "Smart Access | Request Access", "Smart Access | Verify Access"], loc='upper right')
plt.show()