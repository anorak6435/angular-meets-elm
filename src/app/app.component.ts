import { Component, OnInit } from '@angular/core';

// declare var Elm: { Main: { init: (arg0: { node: HTMLElement | null; }) => any; }; };
declare var Elm: any;
// declare function hey(): void;

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  title = 'ng-elm-custom-element';
  messages: string[] = [];

  private elmComponent: any;
  private test?: string;

  ngOnInit() {
    
    // Elm = require("../app/elm-components/elm.js");

    this.initElm();
    this.listenForEvents();
  }

  send(inputElem: HTMLInputElement) {
    this.elmComponent.ports.messageReceiver.send(inputElem.value);
    inputElem.value = '';
  }
  
  private initElm() {
    this.elmComponent = Elm.Main.init({
      node: document.getElementById('elm-component')
    });
  }
  
  private listenForEvents() {
    this.elmComponent.ports.sendMessage.subscribe((message: string) => {
      this.messages.push(message);
    });
  }
}