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

request_IBFT_64 = json.load(open("processed-results/request-IBFT-uint64.json"))
request_IBFT_128 = json.load(open("processed-results/request-IBFT-uint128.json"))
request_IBFT_256 = json.load(open("processed-results/request-IBFT-uint256.json"))

baseline_get_IBFT_block_size = []
baseline_set_IBFT_block_size = []
verify_IBFT_block_size = []
request_IBFT_block_size = []

baseline_get_QBFT_block_size = []
baseline_set_QBFT_block_size = []
verify_QBFT_block_size = []
request_QBFT_block_size = []

baseline_get_RAFT_block_size = []
baseline_set_RAFT_block_size = []
verify_RAFT_block_size = []
request_RAFT_block_size = []


## IBFT, QBFT and RAFT
for i in range(1,12):
    i = str(i)
    for key in baseline_get_IBFT[i]["blocks"].keys():
        baseline_get_IBFT_block_size.append(baseline_get_IBFT[i]["blocks"][key]["size"])   
    for key in baseline_get_QBFT[i]["blocks"].keys():
        baseline_get_QBFT_block_size.append(baseline_get_QBFT[i]["blocks"][key]["size"])   
    for key in baseline_get_RAFT[i]["blocks"].keys():
        baseline_get_RAFT_block_size.append(baseline_get_RAFT[i]["blocks"][key]["size"])               

for i in range(1,12):
    i = str(i)
    for key in baseline_set_IBFT[i]["blocks"].keys():
        baseline_set_IBFT_block_size.append(baseline_set_IBFT[i]["blocks"][key]["size"])               
    for key in baseline_set_QBFT[i]["blocks"].keys():
        baseline_set_QBFT_block_size.append(baseline_set_QBFT[i]["blocks"][key]["size"])               
    for key in baseline_set_RAFT[i]["blocks"].keys():
        baseline_set_RAFT_block_size.append(baseline_set_RAFT[i]["blocks"][key]["size"])                

for i in range(1,12):
    i = str(i)
    for key in verify_IBFT[i]["blocks"].keys():
        verify_IBFT_block_size.append(verify_IBFT[i]["blocks"][key]["size"])        
    for key in verify_QBFT[i]["blocks"].keys():
        verify_QBFT_block_size.append(verify_QBFT[i]["blocks"][key]["size"])        
    for key in verify_RAFT[i]["blocks"].keys():
        verify_RAFT_block_size.append(verify_RAFT[i]["blocks"][key]["size"])        

for i in range(1,12):
    i = str(i)
    for key in request_IBFT[i]["blocks"].keys():
        request_IBFT_block_size.append(request_IBFT[i]["blocks"][key]["size"])        
    for key in request_QBFT[i]["blocks"].keys():
        request_QBFT_block_size.append(request_QBFT[i]["blocks"][key]["size"])        
    for key in request_RAFT[i]["blocks"].keys():
        request_RAFT_block_size.append(request_RAFT[i]["blocks"][key]["size"])        



## Policy length

request_IBFT_transactions_per_block_64 = []
request_IBFT_transactions_per_block_128 = []
request_IBFT_transactions_per_block_256 = []

for i in range(1,12):
    i = str(i)
    for key in request_IBFT_64[i]["blocks"].keys():
        request_IBFT_transactions_per_block_64.append(request_IBFT_64[i]["blocks"][key]["transactions"])
    
    for key in request_IBFT_128[i]["blocks"].keys():
        request_IBFT_transactions_per_block_128.append(request_IBFT_128[i]["blocks"][key]["transactions"])

    for key in request_IBFT_256[i]["blocks"].keys():
        request_IBFT_transactions_per_block_256.append(request_IBFT_256[i]["blocks"][key]["transactions"])

## Transactions size

# key = baseline_get_IBFT["1"]["blocks"].keys()[0]
baseline_get_IBFT_transactions_size = baseline_get_IBFT["1"]["transactions"]["size"]
baseline_set_IBFT_transactions_size = baseline_set_IBFT["1"]["transactions"]["size"]
request_IBFT_transactions_size = request_IBFT["1"]["transactions"]["size"]
verify_IBFT_transactions_size = verify_IBFT["1"]["transactions"]["size"]


matplotlib.rc('xtick', labelsize=12) 
matplotlib.rc('ytick', labelsize=12)

############# plot 1
print("\n\nBaseline GET block size")
print(stats.mean([x / (1024) for x in baseline_get_IBFT_block_size]))
print(stats.stdev([x / (1024) for x in baseline_get_IBFT_block_size]))
print(stats.mean([x / (1024) for x in baseline_get_QBFT_block_size]))
print(stats.stdev([x / (1024) for x in baseline_get_QBFT_block_size]))
print(stats.mean([x / (1024) for x in baseline_get_RAFT_block_size]))
print(stats.stdev([x / (1024) for x in baseline_get_RAFT_block_size]))

print("\n\nBaseline SET block size")
print(stats.mean([x / (1024) for x in baseline_set_IBFT_block_size]))
print(stats.stdev([x / (1024) for x in baseline_set_IBFT_block_size]))
print(stats.mean([x / (1024) for x in baseline_set_QBFT_block_size]))
print(stats.stdev([x / (1024) for x in baseline_set_QBFT_block_size]))
print(stats.mean([x / (1024) for x in baseline_set_RAFT_block_size]))
print(stats.stdev([x / (1024) for x in baseline_set_RAFT_block_size]))

print("\n\nRequest Access")
print(stats.mean([ x / (1024) for x in request_IBFT_block_size]))
print(stats.stdev([ x / (1024) for x in request_IBFT_block_size]))
print(stats.mean([ x / (1024) for x in request_QBFT_block_size]))
print(stats.stdev([ x / (1024) for x in request_QBFT_block_size]))
print(stats.mean([ x / (1024) for x in request_RAFT_block_size]))
print(stats.stdev([ x / (1024) for x in request_RAFT_block_size]))

print("\n\nVerify Access")
print(stats.mean([ x / (1024) for x in verify_IBFT_block_size]))
print(stats.stdev([ x / (1024) for x in verify_IBFT_block_size]))
print(stats.mean([ x / (1024) for x in verify_QBFT_block_size]))
print(stats.stdev([ x / (1024) for x in verify_QBFT_block_size]))
print(stats.mean([ x / (1024) for x in verify_RAFT_block_size]))
print(stats.stdev([ x / (1024) for x in verify_RAFT_block_size]))

############ plot 2
baseline_get_size_growth = np.cumsum([x / (1024) / 1024 for x in baseline_get_IBFT_block_size])
baseline_set_size_growth = np.cumsum([x / (1024) / 1024 for x in baseline_set_IBFT_block_size])
request_access_size_growth = np.cumsum([x / (1024) / 1024 for x in request_IBFT_block_size])
verify_access_size_growth = np.cumsum([x / (1024) / 1024 for x in verify_IBFT_block_size])
plt.plot(baseline_get_size_growth, label="Baseline contract | get")
plt.plot(baseline_set_size_growth, label="Baseline contract | set")
plt.plot(request_access_size_growth, label="Smart Access | Request Access")
plt.plot(verify_access_size_growth, label="Smart Access | Verify Access")
plt.legend(loc="upper left")
plt.tight_layout()
plt.title('Blockchain size growth (IBFT)', fontsize=16)
plt.xlabel('Block number', fontsize=16)
plt.ylabel('Size (MB)', fontsize=16)
plt.show()


# baseline_get_block_size = [x / (1024) for x in baseline_get_IBFT_block_size]
# baseline_set_block_size = [x / (1024) for x in baseline_set_IBFT_block_size]
# request_access_block_size = [ x / (1024) for x in request_IBFT_block_size]
# verify_access_block_size = [ x / (1024) for x in verify_IBFT_block_size]
# plt.plot(baseline_get_block_size[2:-2], label="Baseline contract | get")
# plt.plot(baseline_set_block_size[2:-2], label="Baseline contract | set")
# plt.plot(request_access_block_size[2:-2], label="Smart Access | Request Access")
# plt.plot(verify_access_block_size[2:-2], label="Smart Access | Verify Access")
# plt.legend(loc="upper right", fontsize=16)
# plt.ylim(30, 200)
# plt.tight_layout()
# # plt.title('Quantity of data generated per block')
# plt.xlabel('Block number', fontsize=16)
# plt.ylabel('Size (KB)', fontsize=16)
# plt.show()

############# policy length tps
# fig, ax = plt.subplots()
# # columns = [baseline_get_transactions_per_block[2:-2], baseline_set_transactions_per_block[2:-2], request_access_transactions_per_block[2:-2], verify_access_transactions_per_block[2:-2]]
# bp1 = ax.boxplot(request_IBFT_transactions_per_block_64, positions=[1], notch=True, widths=0.35,
#                  patch_artist=True, boxprops=dict(facecolor="C0"))
# bp2 = ax.boxplot(request_IBFT_transactions_per_block_128, positions=[2], notch=True, widths=0.35,
#                  patch_artist=True, boxprops=dict(facecolor="C1"))
# bp3 = ax.boxplot(request_IBFT_transactions_per_block_256, positions=[3], notch=True, widths=0.35,
#                  patch_artist=True, boxprops=dict(facecolor="C2"))
# plt.legend(loc="upper right")
# plt.ylim(150, 300)
# plt.tight_layout()
# # plt.ylabel('Transactions per second  (TPS) - IB')
# # plt.xlabel('Block number')
# plt.ylabel('Transactions per second  (TPS) - IBFT', fontsize=16)
# ax.legend([bp1["boxes"][0], bp2["boxes"][0], bp3["boxes"][0]], ['Request Access | 64 Attributes', 'Request Access | 128 Attributes', "Request Access | 256 Attributes"], loc='upper right', fontsize=16)
# plt.show()

