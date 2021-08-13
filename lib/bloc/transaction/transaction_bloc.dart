import 'package:dtube_togo/bloc/config/txTypes.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_togo/utils/SecureStorage.dart' as sec;
import 'package:bloc/bloc.dart';
import 'package:dtube_togo/bloc/transaction/transaction_event.dart';
import 'package:dtube_togo/bloc/transaction/transaction_repository.dart';

import 'package:dtube_togo/bloc/transaction/transaction_state.dart';

import 'package:dtube_togo/utils/randomPermlink.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionRepository repository;

  TransactionBloc({required this.repository})
      : super(TransactionInitialState());

  // @override
  // TransactionState get initialState => TransactionInitialState();

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async* {
    final String _avalonApiNode = await sec.getNode();
    final String? _applicationUser = await sec.getUsername();
    final String? _privKey = await sec.getPrivateKey();

    if (event is SetInitState) {
      yield TransactionInitialState();
    }

    if (event is SignAndSendTransactionEvent) {
      String result = "";
      //for (var i = 0; i < 5; i++) {
      //yield TransactionSinging(tx: event.tx);
      try {
        result = "";
        result = await repository
            .sign(event.tx, _applicationUser!, _privKey!)
            .then((value) => repository.send(_avalonApiNode, value));

        if (int.tryParse(result) != null) {
          yield TransactionSent(
              block: int.parse(result),
              successMessage: txTypeFriendlyDescriptionActions[event.tx.type]!
                  .replaceAll(
                      '##DTCAMOUNT',
                      (event.tx.data.amount != null
                              ? event.tx.data.amount! / 100
                              : 0)
                          .toString())
                  .replaceAll('##TIPAMOUNT', event.tx.data.tip.toString())
                  .replaceAll('##USERNAME', event.tx.data.target.toString()),
              txType: event.tx.type,
              isParentContent:
                  (event.tx.data.pa == "" || event.tx.data.pa == null) &&
                      (event.tx.type == 4 || event.tx.type == 13));
        } else {
          yield TransactionError(message: result);
        }
      } catch (e) {
        yield TransactionError(message: e.toString());
      }
    }
    if (event is SendCommentEvent) {
      UploadData _upload = event.uploadData;
      String result = "";

      if (_upload.link == "") {
        _upload.link = randomPermlink(11);
      }
      Map<String, dynamic> jsonMetadata = {};
      // dummy tx
      TxData _txData = new TxData(
        link: _upload.link,
      );

      //comments
      if (_upload.videoLocation == "") {
        jsonMetadata = {
          "title": _upload.title,
          "description": _upload.description,
          "tag": _upload.tag,
        };

        _txData = new TxData(
            link: _upload.link,
            vt: _upload.isEditing
                ? 1
                : (_upload.vpBalance * _upload.vpPercent / 100).floor(),
            tag: _upload.tag,
            pa: _upload.parentAuthor,
            pp: _upload.parentPermlink,
            jsonmetadata: jsonMetadata);

        if (_upload.isPromoted) {
          _txData = new TxData(
              link: _upload.link,
              vt: _upload.isEditing
                  ? 1
                  : (_upload.vpBalance * _upload.vpPercent / 100).floor(),
              tag: _upload.tag,
              jsonmetadata: jsonMetadata,
              pa: _upload.parentAuthor,
              pp: _upload.parentPermlink,
              burn: _upload.burnDtc.floor());
        }
      }
      // video
      if (_upload.videoLocation != "") {
        if (_upload.videoSourceHash != "") {
          jsonMetadata = {
            "files": {
              "ipfs": {
                "vid": {
                  "240": _upload.video240pHash,
                  "480": _upload.video480pHash,
                  "src": _upload.videoSourceHash
                },
                "img": {
                  "118": _upload.thumbnail210Hash,
                  "360": _upload.thumbnail640Hash,
                  "spr": _upload.videoSpriteHash
                },
                "gw": "https://player.d.tube"
              },
            },
            "title": _upload.title,
            "description": _upload.description,
            "dur": _upload.duration,
            "tag": _upload.tag,
            "hide": _upload.unlistVideo ? 1 : 0,
            "nsfw": _upload.nSFWContent ? 1 : 0,
            "oc": _upload.originalContent ? 1 : 0
          };
        } else {
          jsonMetadata = {
            "files": {"youtube": _upload.videoLocation},
            "title": _upload.title,
            "description": _upload.description,
            "dur": _upload.duration,
            "tag": _upload.tag,
            "hide": _upload.unlistVideo ? 1 : 0,
            "nsfw": _upload.nSFWContent ? 1 : 0,
            "oc": _upload.originalContent ? 1 : 0
          };
        }

        _txData = new TxData(
            link: _upload.link,
            vt: _upload.isEditing
                ? 1
                : (_upload.vpBalance * _upload.vpPercent / 100).floor(),
            tag: _upload.tag,
            pa: _upload.parentAuthor != "" ? _upload.parentAuthor : null,
            pp: _upload.parentPermlink != "" ? _upload.parentPermlink : null,
            jsonmetadata: jsonMetadata);

        if (_upload.isPromoted) {
          _txData = new TxData(
              link: _upload.link,
              vt: _upload.isEditing
                  ? 1
                  : (_upload.vpBalance * _upload.vpPercent / 100).floor(),
              tag: _upload.tag,
              jsonmetadata: jsonMetadata,
              pa: _upload.parentAuthor != "" ? _upload.parentAuthor : null,
              pp: _upload.parentPermlink != "" ? _upload.parentPermlink : null,
              burn: _upload.burnDtc.floor());
        }
      }

      Transaction _tx =
          new Transaction(type: _upload.isPromoted ? 13 : 4, data: _txData);

      try {
        result = "";
        result = await repository
            .sign(_tx, _applicationUser!, _privKey!)
            .then((value) => repository.send(_avalonApiNode, value));
        print(result);
        if (int.tryParse(result) != null) {
          yield TransactionSent(
              block: int.parse(result),
              successMessage: txTypeFriendlyDescriptionActions[_tx.type]!,
              txType: _tx.type,
              isParentContent: (_tx.data.pa == "" || _tx.data.pa == null) &&
                  (_tx.type == 4 || _tx.type == 13),
              authorPerm: (_tx.data.pa == "" || _tx.data.pa == null) &&
                      (_tx.type == 4 || _tx.type == 13) &&
                      _tx.data.link != null
                  ? _applicationUser + '/' + _tx.data.link!
                  : null);
        } else {
          yield TransactionError(message: result);
        }
      } catch (e) {
        yield TransactionError(message: e.toString());
      }
    }
  }
}
