import 'dart:async';
import 'package:poll_app/models/vote.dart';

class VoteService {
  // Simüle edilmiş bir API isteği: oyu gönderir ve başarılı döner
  Future<bool> submitVote(Vote vote) async {
    await Future.delayed(const Duration(seconds: 1)); // Ağ gecikmesi simülasyonu
    // Burada gerçek bir http POST isteği yapılabilir
    return true; // Başarılı
  }
} 