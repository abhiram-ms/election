import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

/////////////////////////loading and commanding contracts /////////////////////////////////////////////////

String electionabi = 'assets/abi.json';

// load contract in remix
Future<DeployedContract> loadContract(String contractAddressOwner,bool factory) async {
  if(factory == true){
    electionabi = 'assets/factoryabi.json';
  }else{
    electionabi = 'assets/abi.json';
  }
  String abi = await rootBundle.loadString(electionabi);
  String contractAddress = contractAddressOwner;
  final contract = DeployedContract(ContractAbi.fromJson(abi, 'Election'),
      EthereumAddress.fromHex(contractAddress));
  return contract;
}

//function to call smart contract function
Future<String> callFunction(String funcname, List<dynamic> args, Web3Client ethClient,
    String privateKey,String contractAdressOwner,bool factory) async {
  EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
  DeployedContract contract = await loadContract(contractAdressOwner,factory);
  final ethFunction = contract.function(funcname);
  final result = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: args,
      ),
      chainId: null,
      fetchChainIdFromNetworkId: true);
  return result;
}


//ask function for voting
Future<List<dynamic>> ask(String funcName, List<dynamic> args, Web3Client ethClient,
    String contractAdressOwner,bool factory) async {
  try{
    final contract = await loadContract(contractAdressOwner,factory);
    final ethFunction = contract.function(funcName);
    final result = ethClient.call(contract: contract, function: ethFunction, params: args);
    print('successfullllll');
    return result;
  }catch(e){
    print("catched exception $e");
    return [];
  }
}

////////////////////////////////////Election contract functions //////////////////////////////////////////////

//add candidate function
Future<String> addCandidate(String name, Web3Client ethClient,String adminprivatekey,String contractAdressOwner) async {
    var response =
    await callFunction('addCandidate', [name], ethClient, adminprivatekey,contractAdressOwner,false);
    print('Candidate added successfully');
    return response;
}

//authorize voter
Future<String> authorizeVoter(String address, Web3Client ethClient,String adminprivatekey,String contractAdressOwner) async {
  var response = await callFunction('authorizeVoter',
      [EthereumAddress.fromHex(address)], ethClient, adminprivatekey,contractAdressOwner,false);
  print('Voter Authorized successfully');
  return response;
}
//get total number of candidates
// Future<List> getCandidatesNum(Web3Client ethClient,String contractAdressOwner) async {
//   List<dynamic> result = await ask('getNumCandidates', [], ethClient,contractAdressOwner,false);
//   return result;
// }
//get candidate info list
Future<List> getCandidatesInfoList(Web3Client ethClient,String contractAdressOwner) async {
  List<dynamic> result = await ask('candidateInfo', [], ethClient,contractAdressOwner,false);
  return result;
}

// get election name
Future<List> getelectionName(Web3Client ethClient,String contractAdressOwner) async {
  List<dynamic> result = await ask('getelectionName', [], ethClient,contractAdressOwner,false);
  return result;
}

// get the total number of votes
Future<List> getTotalVotes(Web3Client ethClient,String contractAdressOwner) async {
  List<dynamic> result = await ask('getTotalVotes', [], ethClient,contractAdressOwner,false);
  return result;
}

//candidate info  of the candidate of index (adress of election not contracaddress)
// Future<List> candidateInfo(int index, Web3Client ethClient,String contractAdressOwner) async {
//   List<dynamic> result =
//   await ask('candidateInfo', [BigInt.from(index)], ethClient,contractAdressOwner,false);
//   return result;
// }

//function to vote
Future<String> vote(int candidateIndex, Web3Client ethClient,String voterprivatekey,String contractAdressOwner) async {
  var response = await callFunction(
      "vote", [BigInt.from(candidateIndex)], ethClient, voterprivatekey,contractAdressOwner,false);
  print("Vote counted successfully");
  return response;
}

/////////////////////////////////////// FACTORY FUNCTIONS FOR ELECTION FACTORY ///////////////////////////////////////

//candidate info  of the candidate of index
// Future<List> getDeployedElection(int index, Web3Client ethClient,String contractAdressOwner) async {    //factoryyyyyyyyyyyyyy
//   List<dynamic> result =
//   await ask('getDeployedElection', [BigInt.from(index)], ethClient,contractAdressOwner,true);
//   return result;
// }

//election factory function to get total number of elections
// Future<List> getElectionCounts(Web3Client ethClient,String contractAdressOwner) async {             //factoryyyyyyyyyyyy
//   List<dynamic> result = await ask('getElectionCounts', [], ethClient,contractAdressOwner,true);
//   return result;
// }

//election factory function to get total number of elections
Future<List> getElectionsList(Web3Client ethClient,String contractAdressOwner) async {             //factoryyyyyyyyyyyy
  List<dynamic> result = await ask('getDeployedElection', [], ethClient,contractAdressOwner,true);
  if (kDebugMode) {
    print('this is result returned on electionsList ::: $result ');
  }
  return result;
}

//start Election
Future<String> createElection(String name, Web3Client ethClient, String adminprivatekey,String contractAdressOwner) async {
  var response =
  await callFunction('createElection', [name], ethClient, adminprivatekey,contractAdressOwner,true);    ////faaactoryyyyyyyyyyyyy
  if (kDebugMode) {
    print('Election started successfully');
  }
  return response;
}

//close election
Future<String> closeElection( Web3Client ethClient, String adminprivatekey,String contractAdressOwner) async {
  var response =
  await callFunction('closeElection', [], ethClient, adminprivatekey,contractAdressOwner,true);    ////faaactoryyyyyyyyyyyyy
  if (kDebugMode) {
    print('election ended successfully');
  }
  return response;
}

