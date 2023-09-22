# 2. Format attributes


The "format" keyword is defined to allow interoperable semantic validation for
a fixed subset of values. Currently only `date`, `date-time`, and `time`
attributes are defined and follow RFC 3339 specifications. Validation rules
[5.6][rfc3339-5.6] and the additional restriction rules [5.7][rfc3339-5.7] have
been implemented.

Any other format attributes will not perform validation.


**Note**: Leap seconds cannot be predicted far into the future and are therefore
allowed for every value validated against "time".



[rfc3339-5.6]: https://tools.ietf.org/html/rfc3339#section-5.6
[rfc3339-5.7]: https://tools.ietf.org/html/rfc3339#section-5.7
