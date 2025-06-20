### 手順 4: コードジェネレーター (build_runner) の使い方

`freezed` や `json_serializable` は、私たちが定義したクラスをもとに、必要なコード（`.freezed.dart` や `.g.dart` ファイル）を自動生成します。この生成を実行するのが `build_runner` です。

今後、`@freezed` や `@JsonSerializable()` アノテーションを付けたクラスを作成した後は、ターミナルで以下のコマンドを実行してコードを生成します。

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
