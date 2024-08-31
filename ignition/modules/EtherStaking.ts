import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const EtherStakingModule = buildModule("EtherStakingModule", (m) => {

  const rewardRate = m.getParameter("rewardRate");

  const stakingContract = m.contract("EtherStaking", [rewardRate]);

  return { stakingContract };
});

export default EtherStakingModule;
