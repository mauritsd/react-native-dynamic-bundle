/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  Platform,
  StyleSheet,
  View,
  Button,
  TextInput
} from 'react-native';
import RNDynamicBundle from 'react-native-dynamic-bundle';
import RNFS from 'react-native-fs';

type Props = {};
export default class App extends Component<Props> {
  constructor(props) {
    super(props);

    this.state = {
      url: ""
    }
  }

  componentWillMount = () => {

  }

  render() {
    return (
      <View style={styles.container}>
        <TextInput
          style={styles.textInput}
          onChangeText={(url) => { this.setState({ url });}}
          value={this.state.url}
          autocorrect={false}
          placeholder="URL"
          autoCapitalize="none"
          />
        <Button onPress={this._onReloadButtonPress} title="LOAD" />
      </View>
    );
  }

  _onReloadButtonPress = async () => {
    const { promise } = RNFS.downloadFile({
      fromUrl: this.state.url,
      toFile: RNFS.DocumentDirectoryPath + "/test.bundle",
    });
    const result = await promise;

    RNDynamicBundle.registerBundle('test', 'test.bundle');
    RNDynamicBundle.setActiveBundle('test');
    RNDynamicBundle.reloadBundle();
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  textInput: {
    width: 250,
    height: 40,
    borderColor: 'gray',
    borderWidth: 1,
  }
});
