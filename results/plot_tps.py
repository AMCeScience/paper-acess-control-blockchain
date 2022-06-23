import pandas as pd
import json
import matplotlib.pyplot as plt
import matplotlib 
import numpy as np
import statistics as stats

baseline_get_IBFT = json.load(open("processed-results/baseline-get-IBFT.json"))
baseline_set_IBFT = json.load(open("processed-results/baseline-set-IBFT.json"))
request_IBFT = json.load(open("processed-results/request-IBFT.json"))
verify_IBFT = json.load(open("processed-results/verify-IBFT.json"))

baseline_get_QBFT = json.load(open("processed-results/baseline-get-QBFT.json"))
baseline_set_QBFT = json.load(open("processed-results/baseline-set-QBFT.json"))
request_QBFT = json.load(open("processed-results/request-QBFT.json"))
verify_QBFT = json.load(open("processed-results/verify-QBFT.json"))

baseline_get_RAFT = json.load(open("processed-results/baseline-get-RAFT.json"))
baseline_set_RAFT = json.load(open("processed-results/baseline-set-RAFT.json"))
request_RAFT = json.load(open("processed-results/request-RAFT.json"))
verify_RAFT = json.load(open("processed-results/verify-RAFT.json"))

baseline_get_IBFT_transactions_per_block = []
baseline_set_IBFT_transactions_per_block = []
verify_IBFT_transactions_per_block = []
request_IBFT_transactions_per_block = []

baseline_get_QBFT_transactions_per_block = []
baseline_set_QBFT_transactions_per_block = []
verify_QBFT_transactions_per_block = []
request_QBFT_transactions_per_block = []

baseline_get_RAFT_transactions_per_block = []
baseline_set_RAFT_transactions_per_block = []
verify_RAFT_transactions_per_block = []
request_RAFT_transactions_per_block = []
size_tmp = 0

## IBFT
for i in range(1,12):
    i = str(i)
    for key in baseline_get_IBFT[i]["blocks"].keys():
        baseline_get_IBFT_transactions_per_block.append(baseline_get_IBFT[i]["blocks"][key]["transactions"])
        # baseline_get_gas_used_per_block.append(baseline_get["blocks"][key]["gasUsed"])
        # baseline_get_block_size.append(baseline_get["blocks"][key]["size"])
        size_tmp += baseline_get_IBFT[i]["blocks"][key]["size"]
        # baseline_get_size_growth.append(size_tmp)

for i in range(1,12):
    i = str(i)
    for key in baseline_set_IBFT[i]["blocks"].keys():
        baseline_set_IBFT_transactions_per_block.append(baseline_set_IBFT[i]["blocks"][key]["transactions"])
        # baseline_get_gas_used_per_block.append(baseline_get["blocks"][key]["gasUsed"])
        # baseline_get_block_size.append(baseline_get["blocks"][key]["size"])
        size_tmp += baseline_set_IBFT[i]["blocks"][key]["size"]
        # baseline_get_size_growth.append(size_tmp)

for i in range(1,12):
    i = str(i)
    for key in verify_IBFT[i]["blocks"].keys():
        verify_IBFT_transactions_per_block.append(verify_IBFT[i]["blocks"][key]["transactions"])
        # baseline_get_gas_used_per_block.append(baseline_get["blocks"][key]["gasUsed"])
        # baseline_get_block_size.append(baseline_get["blocks"][key]["size"])
        size_tmp += verify_IBFT[i]["blocks"][key]["size"]
        # baseline_get_size_growth.append(size_tmp)

for i in range(1,12):
    i = str(i)
    for key in request_IBFT[i]["blocks"].keys():
        request_IBFT_transactions_per_block.append(request_IBFT[i]["blocks"][key]["transactions"])
        # baseline_get_gas_used_per_block.append(baseline_get["blocks"][key]["gasUsed"])
        # baseline_get_block_size.append(baseline_get["blocks"][key]["size"])
        size_tmp += request_IBFT[i]["blocks"][key]["size"]
        # baseline_get_size_growth.append(size_tmp)

## QBFT
for i in range(1,12):
    i = str(i)
    for key in baseline_get_QBFT[i]["blocks"].keys():
        baseline_get_QBFT_transactions_per_block.append(baseline_get_QBFT[i]["blocks"][key]["transactions"])
        # baseline_get_gas_used_per_block.append(baseline_get["blocks"][key]["gasUsed"])
        # baseline_get_block_size.append(baseline_get["blocks"][key]["size"])
        size_tmp += baseline_get_QBFT[i]["blocks"][key]["size"]
        # baseline_get_size_growth.append(size_tmp)

for i in range(1,12):
    i = str(i)
    for key in baseline_set_QBFT[i]["blocks"].keys():
        baseline_set_QBFT_transactions_per_block.append(baseline_set_QBFT[i]["blocks"][key]["transactions"])
        # baseline_get_gas_used_per_block.append(baseline_get["blocks"][key]["gasUsed"])
        # baseline_get_block_size.append(baseline_get["blocks"][key]["size"])
        size_tmp += baseline_set_QBFT[i]["blocks"][key]["size"]
        # baseline_get_size_growth.append(size_tmp)

for i in range(1,12):
    i = str(i)
    for key in verify_QBFT[i]["blocks"].keys():
        verify_QBFT_transactions_per_block.append(verify_QBFT[i]["blocks"][key]["transactions"])
        # baseline_get_gas_used_per_block.append(baseline_get["blocks"][key]["gasUsed"])
        # baseline_get_block_size.append(baseline_get["blocks"][key]["size"])
        size_tmp += verify_QBFT[i]["blocks"][key]["size"]
        # baseline_get_size_growth.append(size_tmp)

for i in range(1,12):
    i = str(i)
    for key in request_QBFT[i]["blocks"].keys():
        request_QBFT_transactions_per_block.append(request_QBFT[i]["blocks"][key]["transactions"])
        # baseline_get_gas_used_per_block.append(baseline_get["blocks"][key]["gasUsed"])
        # baseline_get_block_size.append(baseline_get["blocks"][key]["size"])
        size_tmp += request_QBFT[i]["blocks"][key]["size"]
        # baseline_get_size_growth.append(size_tmp)


## RAFT
for i in range(1,12):
    i = str(i)
    for key in baseline_get_RAFT[i]["blocks"].keys():
        baseline_get_RAFT_transactions_per_block.append(baseline_get_RAFT[i]["blocks"][key]["transactions"])
        # baseline_get_gas_used_per_block.append(baseline_get["blocks"][key]["gasUsed"])
        # baseline_get_block_size.append(baseline_get["blocks"][key]["size"])
        size_tmp += baseline_get_RAFT[i]["blocks"][key]["size"]
        # baseline_get_size_growth.append(size_tmp)

for i in range(1,12):
    i = str(i)
    for key in baseline_set_RAFT[i]["blocks"].keys():
        baseline_set_RAFT_transactions_per_block.append(baseline_set_RAFT[i]["blocks"][key]["transactions"])
        # baseline_get_gas_used_per_block.append(baseline_get["blocks"][key]["gasUsed"])
        # baseline_get_block_size.append(baseline_get["blocks"][key]["size"])
        size_tmp += baseline_set_RAFT[i]["blocks"][key]["size"]
        # baseline_get_size_growth.append(size_tmp)

for i in range(1,12):
    i = str(i)
    for key in verify_RAFT[i]["blocks"].keys():
        verify_RAFT_transactions_per_block.append(verify_RAFT[i]["blocks"][key]["transactions"])
        # baseline_get_gas_used_per_block.append(baseline_get["blocks"][key]["gasUsed"])
        # baseline_get_block_size.append(baseline_get["blocks"][key]["size"])
        size_tmp += verify_RAFT[i]["blocks"][key]["size"]
        # baseline_get_size_growth.append(size_tmp)

for i in range(1,12):
    i = str(i)
    for key in request_RAFT[i]["blocks"].keys():
        request_RAFT_transactions_per_block.append(request_RAFT[i]["blocks"][key]["transactions"])
        # baseline_get_gas_used_per_block.append(baseline_get["blocks"][key]["gasUsed"])
        # baseline_get_block_size.append(baseline_get["blocks"][key]["size"])
        size_tmp += request_RAFT[i]["blocks"][key]["size"]
        # baseline_get_size_growth.append(size_tmp)

matplotlib.rc('xtick', labelsize=18) 
matplotlib.rc('ytick', labelsize=18)


###############################################
############## TPS plots ######################
###############################################
############# plot 1
fig, ax = plt.subplots(figsize=(11, 7))
# columns = [baseline_get_transactions_per_block[2:-2], baseline_set_transactions_per_block[2:-2], request_access_transactions_per_block[2:-2], verify_access_transactions_per_block[2:-2]]


bp1 = ax.boxplot(baseline_get_IBFT_transactions_per_block, positions=[0.75], notch=True, widths=0.20,
                 patch_artist=True, boxprops=dict(facecolor="C0"))
bp11 = ax.boxplot(baseline_get_QBFT_transactions_per_block, positions=[1], notch=True, widths=0.20,
                 patch_artist=True, boxprops=dict(facecolor="C1"))
bp111 =  ax.boxplot(baseline_get_RAFT_transactions_per_block, positions=[1.25], notch=True, widths=0.20,
                 patch_artist=True, boxprops=dict(facecolor="C2"))              

# print(stats.mean(baseline_get_IBFT_transactions_per_block))
# print(stats.mean(baseline_get_QBFT_transactions_per_block))
# print(stats.mean(baseline_get_RAFT_transactions_per_block))

bp2 = ax.boxplot(baseline_set_IBFT_transactions_per_block, positions=[1.75], notch=True, widths=0.20,
                 patch_artist=True, boxprops=dict(facecolor="C0"))
bp22 =  ax.boxplot(baseline_set_QBFT_transactions_per_block, positions=[2], notch=True, widths=0.20,
                 patch_artist=True, boxprops=dict(facecolor="C1"))
bp222 = ax.boxplot(baseline_set_RAFT_transactions_per_block, positions=[2.25], notch=True, widths=0.20,
                 patch_artist=True, boxprops=dict(facecolor="C2"))                

# print(stats.mean(baseline_set_IBFT_transactions_per_block))
# print(stats.mean(baseline_set_QBFT_transactions_per_block))
# print(stats.mean(baseline_set_RAFT_transactions_per_block))

bp3 = ax.boxplot(request_IBFT_transactions_per_block, positions=[2.75], notch=True, widths=0.20,
                 patch_artist=True, boxprops=dict(facecolor="C0"))
bp33 = ax.boxplot(request_QBFT_transactions_per_block, positions=[3], notch=True, widths=0.20,
                 patch_artist=True, boxprops=dict(facecolor="C1"))
bp333 = ax.boxplot(request_RAFT_transactions_per_block, positions=[3.25], notch=True, widths=0.20,
                 patch_artist=True, boxprops=dict(facecolor="C2"))
# print(stats.mean(request_IBFT_transactions_per_block))
# print(stats.mean(request_QBFT_transactions_per_block))
# print(stats.mean(request_RAFT_transactions_per_block))


bp4 = ax.boxplot(verify_IBFT_transactions_per_block, positions=[3.75], notch=True, widths=0.20,
                 patch_artist=True, boxprops=dict(facecolor="C0"))
bp44 = ax.boxplot(verify_QBFT_transactions_per_block, positions=[4], notch=True, widths=0.20,
                 patch_artist=True, boxprops=dict(facecolor="C1"))                 
bp444 = ax.boxplot(verify_RAFT_transactions_per_block, positions=[4.25], notch=True, widths=0.20,
                 patch_artist=True, boxprops=dict(facecolor="C2"))                 
print(stats.mean(verify_IBFT_transactions_per_block))
print(stats.mean(verify_QBFT_transactions_per_block))
print(stats.mean(verify_RAFT_transactions_per_block))

          
plt.legend(loc="upper right")
plt.ylim(200, 400)
# plt.ylabel('Transactions per second  (TPS) - IB')
# plt.xlabel('Block number')
plt.xticks([1,2,3,4], ['Baseline GET', 'Baseline SET', 'RequestAccess', 'VerifyAccess'])
plt.ylabel('Transactions per second  (TPS)', fontsize=18)
ax.legend([bp1["boxes"][0], bp11["boxes"][0], bp111["boxes"][0]], ["IBFT", "QBFT", "RAFT"], loc='upper right', fontsize=18)
plt.tight_layout()
plt.show()

############# plot 2
# fig, ax = plt.subplots()
# # columns = [baseline_get_transactions_per_block[2:-2], baseline_set_transactions_per_block[2:-2], request_access_transactions_per_block[2:-2], verify_access_transactions_per_block[2:-2]]
# bp1 = ax.boxplot(baseline_get_QBFT_transactions_per_block, positions=[1], notch=True, widths=0.35,
#                  patch_artist=True, boxprops=dict(facecolor="C0"))
# bp2 = ax.boxplot(baseline_set_QBFT_transactions_per_block, positions=[2], notch=True, widths=0.35,
#                  patch_artist=True, boxprops=dict(facecolor="C1"))
# bp3 = ax.boxplot(request_QBFT_transactions_per_block, positions=[3], notch=True, widths=0.35,
#                  patch_artist=True, boxprops=dict(facecolor="C2"))
# bp4 = ax.boxplot(verify_QBFT_transactions_per_block, positions=[4], notch=True, widths=0.35,
#                  patch_artist=True, boxprops=dict(facecolor="C3"))                 
# plt.legend(loc="upper right")
# plt.ylim(200, 400)
# plt.tight_layout()
# # plt.title('Transactions per second - QBFT')
# # plt.xlabel('Block number')
# plt.ylabel('Transactions per second  (TPS) - QBFT', fontsize=16)
# ax.legend([bp1["boxes"][0], bp2["boxes"][0], bp3["boxes"][0], bp4["boxes"][0]], ['Baseline contract | get', 'Baseline contract | set', "Smart Access | Request Access", "Smart Access | Verify Access"], loc='upper right', fontsize=16)
# plt.show()

############# plot 3
# fig, ax = plt.subplots()
# # columns = [baseline_get_transactions_per_block[2:-2], baseline_set_transactions_per_block[2:-2], request_access_transactions_per_block[2:-2], verify_access_transactions_per_block[2:-2]]
# bp1 = ax.boxplot(baseline_get_RAFT_transactions_per_block, positions=[1], notch=True, widths=0.35,
#                  patch_artist=True, boxprops=dict(facecolor="C0"))
# bp2 = ax.boxplot(baseline_set_RAFT_transactions_per_block, positions=[2], notch=True, widths=0.35,
#                  patch_artist=True, boxprops=dict(facecolor="C1"))
# bp3 = ax.boxplot(request_RAFT_transactions_per_block, positions=[3], notch=True, widths=0.35,
#                  patch_artist=True, boxprops=dict(facecolor="C2"))
# bp4 = ax.boxplot(verify_RAFT_transactions_per_block, positions=[4], notch=True, widths=0.35,
#                  patch_artist=True, boxprops=dict(facecolor="C3"))                 
# plt.legend(loc="upper right")
# plt.ylim(200, 400)
# plt.tight_layout()
# # plt.title('Transactions per second - RAFT')
# # plt.xlabel('Block number')
# plt.ylabel('Transactions per second  (TPS) - RAFT', fontsize=16)
# ax.legend([bp1["boxes"][0], bp2["boxes"][0], bp3["boxes"][0], bp4["boxes"][0]], ['Baseline contract | get', 'Baseline contract | set', "Smart Access | Request Access", "Smart Access | Verify Access"], loc='upper right', fontsize=16)
# plt.show()