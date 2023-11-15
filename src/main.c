#include "socket.h"
#include <stdio.h>

// function to be ran on every connection
void onConn(SOCKET_t conn, void* arg){
    char data[1024] = {0};
    
    // int recvBytes(char buf[], int bufSize, int delay, SOCKET_t sock)
    recvBytes(data, 1024, 0, conn);
    puts(data);

    sendBytes("HTTP/1.1 200 OK\n\nhi", 19, conn);
}

int main(){
    SOCKET_t sock = createSock();
    errCode e;

    // errCode initSock(SOKCET_t sock)
    if((e=initSock(sock)) != no_err) throwError(e);

    // errCode bindSock(const char* hostname, int port, SOCKET_t sock);
    if((e = bindSock("127.0.0.1", 8080, sock)) != no_err)
        throwError(e);

    /*
     * errCode listenSock(void (*onConn)(SOCKET_t conn, void* arg), int maxConn, SOCKET_t sock, void* arg)
     *
     * onConn: a function that is ran on each connection to the binded sock
     * maxConn: maximum ammount of connections
     * arg: a argument that is passed to the `onConn` func when a connection is made
    */
    if((e = listenSock(onConn, 10, sock, NULL)) != no_err)
        throwError(e);
}